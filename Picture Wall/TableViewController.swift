//
//  TableViewController.swift
//  Picture Wall
//
//  Created by murad on 28/05/2019.
//  Copyright © 2019 murad. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var pictureArray = [Picture]()
    var textPicture = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addRightBarButtonItem()
        
        loadPicture()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return pictureArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PictureCell", for: indexPath) as? PictureViewCell else {
            fatalError("Unable to dequeuePersonCell")
        }
        
        cell.textOnLabel.text = pictureArray[indexPath.row].pictureName
        
        let path = getDocumentsDirectory().appendingPathComponent(pictureArray[indexPath.row].image)
        cell.picture.image = UIImage.init(contentsOfFile: path.path)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.selectedPicture = getDocumentsDirectory().appendingPathComponent(pictureArray[indexPath.row].image)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if (editingStyle == .delete) {
            pictureArray.remove(at: indexPath.row)
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .middle)
            tableView.endUpdates()
            savePicture()
        }
        
    }
    
    //MARK: - UI
    
    func addRightBarButtonItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPicture))
    }

    @objc func addNewPicture() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            picker.sourceType = .photoLibrary
        }
        
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        
        dismiss(animated: true)
        
        addPictureText()
        
        let picture = Picture(pictureName: textPicture, image: imageName)
        pictureArray.append(picture)
        tableView.reloadData()
        
        savePicture()
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func savePicture() {
        let jsonEncoder = JSONEncoder()
        if let savedData = try? jsonEncoder.encode(pictureArray) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "people")
        } else {
            print("Failed to save people.")
        }
    }
    
    func loadPicture() {
        let defaults = UserDefaults.standard
        
        if let savedPeople = defaults.object(forKey: "people") as? Data {
            let jsonDecoder = JSONDecoder()
            
            do {
                pictureArray = try jsonDecoder.decode([Picture].self, from: savedPeople)
            } catch {
                print("Failed to load people")
            }
        }
    }
    
    func addPictureText() {
        let ac = UIAlertController(title: "Add text for picture", message: nil, preferredStyle: .alert)
        ac.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Text"
        }
        ac.addAction(UIAlertAction(title: "Add", style: .default, handler: { [weak self, weak ac] action in
            guard let item = ac?.textFields?[0].text else { return }
            
            self?.textPicture = item
        }))
        present(ac, animated: true)
    }
 
}
