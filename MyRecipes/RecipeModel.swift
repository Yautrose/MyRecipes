import RealmSwift

class Recipe: Object {
    
    @Persisted(primaryKey: true) var id: String
    @Persisted var name: String = ""
    @Persisted var tags: String?
    @Persisted var recipeImage: Data?
    @Persisted var date = Date()
    @Persisted var rating = 0

    
    convenience init(id: String = UUID().uuidString,
                     name: String,
                     tags: String?,
                     recipeImage: Data?,
                     rating: Int) {
        self.init()
        self.id = id
        self.name = name
        self.tags = tags
        self.recipeImage = recipeImage
        self.rating = rating
    }
}
