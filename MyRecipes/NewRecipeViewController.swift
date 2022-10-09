import UIKit
import RealmSwift

class NewRecipeViewController: UITableViewController {
    
    var imageIsChanged = false
    var currentRecipe: Recipe!

    @IBOutlet var imageOfRecipe: UIImageView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var nameOfRecipe: UITextField!
    @IBOutlet weak var tagsOfRecipe: UITextField!
    @IBOutlet weak var ratingControl: RatingControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = UIView()
        saveButton.isEnabled = false
        nameOfRecipe.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        setupEditScreen()
    }
    
// MARK: - Table View Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let cameraIcon = #imageLiteral(resourceName: "camera")
            let photoIcon = #imageLiteral(resourceName: "photo")
            let actionSheet = UIAlertController(title: nil,
                                                message: nil,
                                                preferredStyle: .actionSheet)
            
            let camera = UIAlertAction(title: "Camera", style: .default) { _ in
                self.chooseImagePicker(source: .camera)
            }
            camera.setValue(cameraIcon, forKey: "image")
            camera.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
            
            let photo = UIAlertAction(title: "Photo", style: .default) { _ in
                self.chooseImagePicker(source: .photoLibrary)
            }
            photo.setValue(photoIcon, forKey: "image")
            photo.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
            let cancel = UIAlertAction(title: "Cancel", style: .cancel)
            
            actionSheet.addAction(camera)
            actionSheet.addAction(photo)
            actionSheet.addAction(cancel)
            
            present(actionSheet, animated: true)
            
        } else {
            view.endEditing(true)
        }
    }
    
    func saveRecipe() {
        var image: UIImage?
        
        if imageIsChanged {
            image = imageOfRecipe.image
        } else {
            image = #imageLiteral(resourceName: "imagePlaceholder")
        }
        
        let imageData = image?.pngData()
        let newRecipe = Recipe(name: nameOfRecipe.text!,
                               tags: tagsOfRecipe.text,
                               recipeImage: imageData,
                               rating: ratingControl.rating)
        
        if currentRecipe != nil {
            let realm = try! Realm()
            try! realm.write {
                currentRecipe?.name = newRecipe.name
                currentRecipe?.tags = newRecipe.tags
                currentRecipe?.recipeImage = newRecipe.recipeImage
                currentRecipe?.rating = newRecipe.rating
            }
        } else {
            StorageManager.saveRecipe(newRecipe)
        }
        
    }
    
    private func setupEditScreen() {
        if currentRecipe != nil {
            
            setupNavigationBar()
            imageIsChanged = true
            guard let data = currentRecipe?.recipeImage, let image = UIImage(data: data) else { return }
            
            imageOfRecipe.image = image
            imageOfRecipe.contentMode = .scaleAspectFill
            nameOfRecipe.text = currentRecipe?.name
            tagsOfRecipe.text = currentRecipe?.tags
            ratingControl.rating = currentRecipe.rating
        }
    }
    
    private func setupNavigationBar() {
        if let topBar = navigationController?.navigationBar.topItem {
            topBar.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
        navigationItem.leftBarButtonItem = nil
        title = currentRecipe?.name
        saveButton.isEnabled = true
    }
    
    @IBAction func cancelAction(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
}
    
// MARK: - Extensions

extension NewRecipeViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc private func textFieldChanged() {
        if nameOfRecipe.text?.isEmpty == false {
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
    }
}
        
extension NewRecipeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func chooseImagePicker(source: UIImagePickerController.SourceType){
        
        if UIImagePickerController.isSourceTypeAvailable(source) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = source
            present(imagePicker, animated: true)
            
        }
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageOfRecipe.image = info[.editedImage] as? UIImage
        imageOfRecipe.contentMode = .scaleAspectFill
        imageOfRecipe.clipsToBounds = true
        imageIsChanged = true
        dismiss(animated: true)
    }
}

