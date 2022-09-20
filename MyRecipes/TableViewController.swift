import UIKit
import RealmSwift

class TableViewController: UITableViewController {

    var recipes: Results<Recipe>?
//    private var token: NotificationToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let realm = try! Realm()
        recipes = realm.objects(Recipe.self)
//        token?.invalidate()
//        token = recipes!.observe { [weak self] (changes: RealmCollectionChange) in
//            guard let tableView = self?.tableView else { return }
//            switch changes {
//            case .initial:
//                tableView.reloadData()
//            case .update(_, let deletions, let insertions, let modifications):
//                tableView.performBatchUpdates({
//                    tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}), with: .automatic)
//                    tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }), with: .automatic)
//                    tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }), with: .automatic)
//                }, completion: { finished in
//                    // ...
//                })
//            case .error(let error):
//                fatalError("\(error)")
//            }
//        }
        
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

    @IBAction func unwindSegue(_ segue: UIStoryboardSegue) {
        guard let newRecipeVC = segue.source as? NewRecipeViewController else { return }
        newRecipeVC.saveNewRecipe()
        tableView.reloadData()
    }
    
}
