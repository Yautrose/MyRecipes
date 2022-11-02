import UIKit
import RealmSwift

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    let searchController = UISearchController(searchResultsController: nil)
    var recipes: Results<Recipe>?
    var filteredRecipes: Results<Recipe>?
    var ascendingSorting = true
    var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var reversedSortingButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let realm = try! Realm()
        recipes = realm.objects(Recipe.self)
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredRecipes!.count
        }
        return recipes?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell
        
        var recipe = Recipe()
        if isFiltering {
            recipe = filteredRecipes![indexPath.row]
        } else {
            recipe = recipes![indexPath.row]
        }

        cell.nameOfRecipe.text = recipe.name
        cell.tagsOfRecipe.text = recipe.tags
        cell.imageOfRecipe.image = UIImage(data: recipe.recipeImage!)
        
        
        cell.imageOfRecipe.layer.cornerRadius = cell.imageOfRecipe.frame.size.height / 2
        cell.imageOfRecipe.clipsToBounds = true
        
        if recipe.rating == 1 {
            cell.firstStar.image = #imageLiteral(resourceName: "filledStar")
        } else if recipe.rating == 2 {
            cell.firstStar.image = #imageLiteral(resourceName: "filledStar")
            cell.secondStar.image = #imageLiteral(resourceName: "filledStar")
        } else if recipe.rating == 3 {
            cell.firstStar.image = #imageLiteral(resourceName: "filledStar")
            cell.secondStar.image = #imageLiteral(resourceName: "filledStar")
            cell.thirdStar.image = #imageLiteral(resourceName: "filledStar")
        } else if recipe.rating == 4 {
            cell.firstStar.image = #imageLiteral(resourceName: "filledStar")
            cell.secondStar.image = #imageLiteral(resourceName: "filledStar")
            cell.thirdStar.image = #imageLiteral(resourceName: "filledStar")
            cell.fourthStar.image = #imageLiteral(resourceName: "filledStar")
        } else if recipe.rating == 5 {
            cell.firstStar.image = #imageLiteral(resourceName: "filledStar")
            cell.secondStar.image = #imageLiteral(resourceName: "filledStar")
            cell.thirdStar.image = #imageLiteral(resourceName: "filledStar")
            cell.fourthStar.image = #imageLiteral(resourceName: "filledStar")
            cell.fifthStar.image = #imageLiteral(resourceName: "filledStar")
        }
        
        return cell
    }
    
    // MARK: - Table view delegate
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
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
            var recipe = Recipe()
            if isFiltering {
                recipe = filteredRecipes![indexPath.row]
            } else {
                recipe = recipes![indexPath.row]
            }
            let newRecipeVC = segue.destination as! NewRecipeViewController
            newRecipeVC.currentRecipe = recipe
            
        }
    }
    
    @IBAction func sortSelection(_ sender: UISegmentedControl) {
       sorting()
    }
    
    @IBAction func reversedSorting(_ sender: Any) {
        ascendingSorting.toggle()
        
        if ascendingSorting {
            reversedSortingButton.image = #imageLiteral(resourceName: "AZ")
        } else {
            reversedSortingButton.image = #imageLiteral(resourceName: "ZA")
        }
        
        sorting()
    }
    
    private func sorting() {
        if segmentedControl.selectedSegmentIndex == 0 {
            recipes = recipes?.sorted(byKeyPath: "date", ascending: ascendingSorting)
        } else {
            recipes = recipes?.sorted(byKeyPath: "name", ascending: ascendingSorting)
        }
        
        tableView.reloadData()
    }
    
    @IBAction func unwindSegue(_ segue: UIStoryboardSegue) {
        guard let newRecipeVC = segue.source as? NewRecipeViewController else { return }
        newRecipeVC.saveRecipe()
        tableView.reloadData()
    }
    
}

extension MainViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    private func filterContentForSearchText(_ searchText: String) {
        filteredRecipes = recipes?.filter("name CONTAINS[c] %@ OR tags CONTAINS[c] %@", searchText, searchText)
        tableView.reloadData()
    }
}
