import UIKit
import RealmSwift

class TableViewController: UITableViewController {

    var recipes: Results<Recipe>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let realm = try! Realm()
        recipes = realm.objects(Recipe.self)
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return recipes?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell
        
        let recipe = recipes![indexPath.row]

        cell.nameOfRecipe.text = recipe.name
        cell.tagsOfRecipe.text = recipe.tags
        cell.imageOfRecipe.image = UIImage(data: recipe.recipeImage!)
        
        
        cell.imageOfRecipe.layer.cornerRadius = cell.imageOfRecipe.frame.size.height / 2
        cell.imageOfRecipe.clipsToBounds = true

        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let recipe = recipes![indexPath.row]
        let contextItem = UIContextualAction(style: .destructive, title: "Delete") { (_, _, _) in
            StorageManager.deleteRecipe(recipe)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        let swipeActions = UISwipeActionsConfiguration(actions: [contextItem])

        return swipeActions
    }

   
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let recipe = recipes![indexPath.row]
            let newRecipeVC = segue.destination as! NewRecipeViewController
            newRecipeVC.currentRecipe = recipe
            
        }
    }

    @IBAction func unwindSegue(_ segue: UIStoryboardSegue) {
        guard let newRecipeVC = segue.source as? NewRecipeViewController else { return }
        newRecipeVC.saveRecipe()
        tableView.reloadData()
    }
    
}
