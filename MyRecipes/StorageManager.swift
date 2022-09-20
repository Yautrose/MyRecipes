import RealmSwift

class StorageManager {
    
    static func saveRecipe(_ recipe: Recipe) {
        let realm = try! Realm()
        try! realm.write{
            realm.add(recipe)
        }
    }
    
    static func deleteRecipe(_ recipe: Recipe) {
        let realm = try! Realm()
        try! realm.write {
            realm.delete(recipe)
        }
    }

}
