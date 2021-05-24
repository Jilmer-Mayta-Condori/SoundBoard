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
        let cell = UITableViewCell()
        let grabacion = grabaciones[indexPath.row]
        cell.textLabel?.text = grabacion.nombre
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let grabacion = grabaciones[indexPath.row]
        do {
            reproducirAudio = try AVAudioPlayer(data: grabacion.audio! as Data)
            reproducirAudio?.play()
            print(grabacion)
        } catch {}
        tablaGrabaciones.deselectRow(at: indexPath, animated: true)
    }


}

