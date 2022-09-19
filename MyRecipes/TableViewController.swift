import UIKit

class TableViewController: UITableViewController {

    var recipes = [Recipe(name: "Бургер с курицей", tags: "Курица", image: "Бургер с курицей"),
                   Recipe(name: "Рыба красная", tags: "Рыба", image: "Рыба красная"),
                   Recipe(name: "Стейк", tags: "Говядина", image: "Стейк")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return recipes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell
        
        let recipe = recipes[indexPath.row]

        cell.nameOfRecipe.text = recipe.name
        cell.tagsOfRecipe.text = recipe.tags
        
        if recipe.recipeImage == nil {
            cell.imageOfRecipe.image = UIImage.init(named: recipe.image!)
        } else {
            cell.imageOfRecipe.image = recipe.recipeImage
        }
        
        cell.imageOfRecipe.layer.cornerRadius = cell.imageOfRecipe.frame.size.height / 2
        cell.imageOfRecipe.clipsToBounds = true

        return cell
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func unwindSegue(_ segue: UIStoryboardSegue) {
        guard let newRecipeVC = segue.source as? NewRecipeViewController else { return }
        newRecipeVC.saveNewRecipe()
        recipes.append(newRecipeVC.newRecipe!)
        tableView.reloadData()
    }
    
}
