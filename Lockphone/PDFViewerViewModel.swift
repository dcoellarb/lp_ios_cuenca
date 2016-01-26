/**
 View Model for the utilitiy class to dispaly pdfs in the app

 author: dcoellar

 created: 2015-12-15
 **/

import Foundation
import M13PDFKit

class PDFViewerViewModel {

    var title: String
    var filename: String
    var type: String
    var document: PDFKDocument?

    /*
     Initializer that receives the name of the file to display

     author: dcoellar

     created: 2015-12-15

     :param: filename : String - the name/path to the file internally in the device
     */
    init(title: String, filename: String) {
        self.title = title
        self.filename = filename
        self.type = "pdf"
        if !self.filename.isEmpty {
            self.document = PDFKDocument(contentsOfFile:NSBundle.mainBundle().pathForResource(self.filename, ofType:self.type), password: nil)
        }
    }

    /*
    Initializer that receives the name and type of the file to display

     author: dcoellar

     created: 2015-12-15

     :param: filename : String - the name/path to the file internally in the device
     :param: type : String - the type of file i.e. pdf
     */
    init(title: String, filename: String, type: String) {
        self.title = title
        self.filename = filename
        self.type = type
        if !self.filename.isEmpty && !self.type.isEmpty {
            self.document = PDFKDocument(contentsOfFile:NSBundle.mainBundle().pathForResource(self.filename, ofType:self.type), password: nil)
        }
    }
}
