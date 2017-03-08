import Foundation

class MonitorDashboard: NSObject, NSCoding {

    var id: UUID
    var url: String
    var columns: Int

    init(id: UUID, url: String, columns: Int) {
        self.id = id
        self.url = url
        self.columns = columns
    }

    init(url: String, columns: Int) {
        self.id = UUID()
        self.url = url
        self.columns = columns
    }

    //MARK: - NSCoding -

    init(dictionary: Dictionary<String, Any>) {
        url = dictionary["url"] as! String
        columns = dictionary["columns"] as! Int
        id = dictionary["id"] as! UUID
    }

    required init(coder decoder: NSCoder) {
        url = decoder.decodeObject(forKey: "url") as! String
        columns = decoder.decodeInteger(forKey: "columns")
        id = decoder.decodeObject(forKey: "id") as! UUID
    }

    func encode(with coder: NSCoder) {
        coder.encode(url, forKey: "url")
        coder.encode(columns, forKey: "columns")
        coder.encode(id, forKey: "id")
    }
}
