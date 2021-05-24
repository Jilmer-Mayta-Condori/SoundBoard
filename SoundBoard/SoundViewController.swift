

import UIKit
import AVFoundation

class SoundViewController: UIViewController {
    
    @IBOutlet weak var grabarButton: UIButton!
    @IBOutlet weak var reproducirButton: UIButton!
    @IBOutlet weak var nombreTextField: UITextField!
    @IBOutlet weak var agregarButton: UIButton!
    
    var grabarAudio: AVAudioRecorder?
    var reproducirAudio: AVAudioPlayer?
    var audioURL:URL?

    override func viewDidLoad() {
        super.viewDidLoad()
        configurarGrabacion()
        reproducirButton.isEnabled = false
        agregarButton.isEnabled = false

    }
    
    @IBAction func grabarTapped(_ sender: Any) {
        if grabarAudio!.isRecording{
            //Detenemos la grabaciòn
            grabarAudio?.stop()
            //Cambiamos el texto de nuestro boton grabar
            grabarButton.setTitle("GRABAR", for: .normal)
            reproducirButton.isEnabled = true
            agregarButton.isEnabled = true
        }else{
            //Empezamos la grabaciòn
            grabarAudio?.record()
            //Cambiamos el texto de nuestro boton grabar a detenener
            grabarButton.setTitle("DETENER", for: .normal)
            reproducirButton.isEnabled = false
            
        }
    }
    
    @IBAction func reproducirTapped(_ sender: Any) {
        do {
            try reproducirAudio = AVAudioPlayer(contentsOf: audioURL!)
            reproducirAudio!.play()
            print("Reproduciendo")
        } catch {}
    }
    
    @IBAction func agregarTapped(_ sender: Any) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let grabacion = Grabacion(context: context)
        grabacion.nombre = nombreTextField.text
        grabacion.audio = NSData(contentsOf: audioURL!)! as Data
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        navigationController!.popViewController(animated: true)
    }
    
    func configurarGrabacion(){
        do {
            //creando sesion de audio
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: [])
            try session.overrideOutputAudioPort(.speaker)
            try session.setActive(true)
            
            //creando direccion para el archivo de audio
            let basePath:String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let pathComponets = [basePath, "audio.m4a"]
            audioURL = NSURL.fileURL(withPathComponents: pathComponets)!
            
            //impresion de ruta donde se guardan los archivos
            print("*************************")
            print(audioURL!)
            print("*************************")
            
            //crear opciones para el grabador de aduio
            var settings:[String:AnyObject] = [:]
            settings[AVFormatIDKey] = Int(kAudioFormatMPEG4AAC) as AnyObject?
            settings[AVSampleRateKey] = 44100.0 as AnyObject?
            settings[AVNumberOfChannelsKey] = 2 as AnyObject?
            
            //crear el objeto de grabacion de audio
            grabarAudio = try AVAudioRecorder(url: audioURL!, settings: settings)
            grabarAudio!.prepareToRecord()
            
        } catch let error as NSError {
            print(error)
        }
    }
}
