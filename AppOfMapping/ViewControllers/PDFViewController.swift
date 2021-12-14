//
//  PDFViewController.swift
//  Slaad
//
//  Created by PJ Gray on 6/5/19.
//  Copyright © 2019 Say Goodnight. All rights reserved.
//

import UIKit
import PDFKit

class PDFViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let times = UIImage.fontAwesomeIcon(name: .times, style: .solid, textColor: .white, size: CGSize(width: 25.0, height: 25.0))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: times, style: .plain, target: self, action: #selector(tappedHide))

        // Add PDFView to view controller.
        let pdfView = PDFView(frame: self.view.bounds)
        pdfView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(pdfView)
        
        // Fit content in PDFView.
        pdfView.autoScales = true
        
        // Load Sample.pdf file from app bundle.
        let fileURL = Bundle.main.url(forResource: "ogl", withExtension: "pdf")
        pdfView.document = PDFDocument(url: fileURL!)
        
    }

    @objc func tappedHide() {
        self.dismiss(animated: true, completion: nil)
    }
    
}
