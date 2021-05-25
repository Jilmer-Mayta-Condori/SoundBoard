//
//  ViewController.swift
//  SoundBoard
//
//  Created by Jilmer on 5/24/21.
//  Copyright © 2021 Jilmer. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tablaGrabaciones: UITableView!
    
    var reproducirAudio: AVAudioPlayer?
    
    var grabaciones:[Grabacion] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tablaGrabaciones.delegate = self
        tablaGrabaciones.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do {
            grabaciones = try context.fetch(Grabacion.fetchRequest())
            tablaGrabaciones.reloadData()
        } catch {}
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return grabaciones.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let grabacion = grabaciones[indexPath.row]
        cell.textLabel?.text = grabacion.nombre
        cell.detailTextLabel?.text = obtenerDuracion(grabacion: grabacion)
        return cell
    }
    
    func obtenerDuracion(grabacion: Grabacion) -> String{
        do {
            reproducirAudio = try AVAudioPlayer(data: grabacion.audio! as Data)
            
            let seconds : Float64 = reproducirAudio!.duration

            let mySecs = Int(seconds) % 60
            let myMins = Int(seconds) / 60

            let myTimes = String(myMins) + ":" + String(mySecs)
            return myTimes
        } catch {
            return "00:00"
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let grabacion = grabaciones[indexPath.row]
        do {
            reproducirAudio = try AVAudioPlayer(data: grabacion.audio! as Data)
            reproducirAudio?.play()
            print(reproducirAudio!.duration)
            print(grabacion)
        } catch {}
        tablaGrabaciones.deselectRow(at: indexPath, animated: true)
    }
    	
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let grabacion = grabaciones[indexPath.row]
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            context.delete(grabacion)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            do{
                grabaciones = try context.fetch(Grabacion.fetchRequest())
                tablaGrabaciones.reloadData()
            }catch{}

        }
    }


}

