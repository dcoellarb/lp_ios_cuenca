/**
 View Controller for the utilitiy class to dispaly pdfs in the app

 author: dcoellar

 created: 2015-12-15
 **/

import Foundation
import UIKit
import M13PDFKit
import SnapKit
import TTOpenInAppActivity

class PDFViewerViewController: UIViewController {

    var viewModel: PDFViewerViewModel
    var backbutton: UIBarButtonItem?
    var flexibleSpace: UIBarButtonItem?
    var sharebutton: UIBarButtonItem?

    /*
     Initializer gets viewModel injected

     author: dcoellar

     created: 2015-12-15

     :param: viewModel : PDFViewerViewModel - view model injected
    */
    init(viewModel: PDFViewerViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /*
     Override of view did load, set the bar and the pdf reader

     author: dcoellar

     created: 2015-12-15

    */
    override func viewDidLoad() {
        let toolbar = UIToolbar()
        toolbar.backgroundColor = Colors.white
        toolbar.tintColor = Colors.red
        toolbar.barTintColor = Colors.white
        toolbar.translucent = false
        toolbar.layer.borderWidth = 1
        toolbar.layer.borderColor = Colors.white.CGColor
        let backImage = UIButton(frame: CGRectMake(0, 0, 33, 33))
        backImage.setImage(UIImage(named: "back"), forState: .Normal)
        backImage.addTarget(self, action: "closeViewer", forControlEvents:  .TouchUpInside)
        let backbutton = UIBarButtonItem(customView: backImage)
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let title = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width * 0.8, height: 44))
        title.text = viewModel.title
        title.textAlignment = NSTextAlignment.Center
        title.textColor = Colors.red
        title.font = Font.boldFontWithSize(18)

        let titleBarItem = UIBarButtonItem(customView: title)
        let flexibleSpace1 = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let sharebutton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Action, target: self, action: "send")
        toolbar.setItems([backbutton, flexibleSpace, titleBarItem, flexibleSpace1, sharebutton], animated: false)
        self.view.addSubview(toolbar)
        toolbar.snp_updateConstraints {
            $0.top.equalTo(self.view.snp_top).offset(20)
            $0.left.equalTo(self.view.snp_left)
            $0.right.equalTo(self.view.snp_right)
            $0.height.equalTo(44)
        }
        let pageCollectionView = PDFKBasicPDFViewerSinglePageCollectionView.init(frame: self.view.bounds, andDocument: viewModel.document)
        pageCollectionView.translatesAutoresizingMaskIntoConstraints = false
        pageCollectionView.singlePageDelegate = self
        self.view.addSubview(pageCollectionView)
        pageCollectionView.snp_updateConstraints {
            $0.top.equalTo(toolbar.snp_bottom)
            $0.left.equalTo(self.view.snp_left)
            $0.right.equalTo(self.view.snp_right)
            $0.bottom.equalTo(self.view.snp_bottom)
        }
    }

    /**
     Function that closes the current view

     author: dcoellar

     created: 2015-12-15

     **/
    func closeViewer() {
        self.view.endEditing(true)
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    /**
     Function that shares the pdf

     author: dcoellar

     created: 2015-12-15

     **/
    func send() {
        let openInAppActivity = TTOpenInAppActivity(view: self.view, andBarButtonItem: sharebutton)
        let activityViewController = UIActivityViewController(activityItems: [viewModel.document!.fileURL], applicationActivities: [openInAppActivity])
        if (openInAppActivity) != nil {
            openInAppActivity.superViewController = activityViewController
        }
        self.presentViewController(activityViewController, animated:true, completion:nil)
    }
}

/**
 Extension that implements PDFKBasicPDFViewerSinglePageCollectionViewDelegate

 author: dcoellar

 created: 2015-12-15

 **/
extension PDFViewerViewController : PDFKBasicPDFViewerSinglePageCollectionViewDelegate {

    func singlePageCollectionView(collectionView: PDFKBasicPDFViewerSinglePageCollectionView!, didDisplayPage page: UInt) {
        self.viewModel.document!.currentPage = page
    }

}
