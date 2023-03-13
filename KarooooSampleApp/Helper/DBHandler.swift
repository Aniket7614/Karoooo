
import Foundation
import SQLite3

class Databasehandler {
    let databaseName : String = "UserDB"
    let databaseExtension : String = "db"
    var db : OpaquePointer! = nil
    
    init() {
         prepareDatafile()
         db = openDatabase()
    }
    
    func executeSelect(username:String , password:String)->LoginData{
        
        var data = LoginData()
        let query = "select * from LoginData where Username = '"+username+"' and Password = '"+password+"'"
        var queryStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, query, -1, &queryStatement, nil) == SQLITE_OK {
            if  sqlite3_step(queryStatement) == SQLITE_ROW
            {
                let c1 = sqlite3_column_text(queryStatement, 0)
                if c1 != nil{
                    data.Username = String(cString: c1!)
                }
                let c2 = sqlite3_column_text(queryStatement, 1)
                if c2 != nil{
                    data.Password = String(cString: c2!)
                }
            }
        } else {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            
        }
        
        sqlite3_finalize(queryStatement!)
        return data
    }
    
    func loginAuthentication(username:String , password:String)->Bool{
        
        let query = "select * from LoginData where Username = '"+username+"' and Password = '"+password+"'"
        var queryStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, query, -1, &queryStatement, nil) == SQLITE_OK {
            if  sqlite3_step(queryStatement) == SQLITE_ROW
            {
                sqlite3_finalize(queryStatement)
                return true
            }
        } else {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("'insert into ':: could not be prepared::\(errmsg)")
        }
        sqlite3_finalize(queryStatement)
        return false
    }
    
    func executeQuery(query: String)->Bool{
        
        var queryStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, query, -1, &queryStatement, nil) == SQLITE_OK {
            if sqlite3_step(queryStatement) != SQLITE_DONE {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("failure inserting hero: \(errmsg)")
            }
            else{
                return true
            }
            
        } else {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("'insert into ':: could not be prepared::\(errmsg)")
        }
        sqlite3_finalize(queryStatement)
        return false
    }
    
    //++++++++++++++++++++++ Deleting from database++++++++++++++++++
    
    func deleteQuery(query: String)->Bool{
        
        var deleteStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, query, -1, &deleteStatement, nil) == SQLITE_OK {
    
            if sqlite3_step(deleteStatement) != SQLITE_DONE {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("failure inserting hero: \(errmsg)")
                
            } else {
               return true
                
                
            }
        } else {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("'insert into ':: could not be prepared::\(errmsg)")

        }
    
    
    
    
        sqlite3_finalize(deleteStatement)
    
    
        print("delete")
        return false
    
    
    }
    
    /////////////////////////////
    //Copy database for fist time
    /////////////////////////////
    func prepareDatafile()
    {
        let docUrl=NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        print(docUrl)
        let fdoc_url=URL(fileURLWithPath: docUrl).appendingPathComponent("\(databaseName).\(databaseExtension)")
        
        let filemanager=FileManager.default
        
        if !FileManager.default.fileExists(atPath: fdoc_url.path){
            do{
                let localUrl=Bundle.main.url(forResource: databaseName, withExtension: databaseExtension)
                print(localUrl?.path ?? "")
                
                try filemanager.copyItem(atPath: (localUrl?.path)!, toPath: fdoc_url.path)
                
                print("Database copied to simulator-device")
            }catch
            {
                print("error while copying")
            }
        }
        else{
            print("Database alreayd exists in similator-device")
        }
    }
    
    
    
    /////////////////////////////////////
    /////Open Connection to Database
    ////////////////////////////////////
    func openDatabase() -> OpaquePointer? {
        
        let docUrl=NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        print(docUrl)
        let fdoc_url=URL(fileURLWithPath: docUrl).appendingPathComponent("\(databaseName).\(databaseExtension)")
        
        var db: OpaquePointer? = nil
        
        if sqlite3_open(fdoc_url.path, &db) == SQLITE_OK {
            print("DB Connection Opened, Path is :: \(fdoc_url.path)")
            return db
        } else {
            print("Unable to open database. Verify that you created the directory described " +
                "in the Getting Started section.")
            return nil
        }
        
    }

}
