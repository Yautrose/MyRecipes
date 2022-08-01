import UIKit

class TableViewController: UITableViewController {

    let recipes = [Recipe(name: "Бургер с курицей", tags: "Курица", image: "Бургер с курицей"),
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

        cell.nameOfRecipe.text = recipes[indexPath.row].name
        cell.tagsOfRecipe.text = recipes[indexPath.row].tags
        cell.imageOfRecipe.image = UIImage.init(named: recipes[indexPath.row].image)
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

    @IBAction func cancelAction(_ segue: UIStoryboardSegue) {}
    
}
