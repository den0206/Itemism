//
//  PopupViewController.swift
//  Itemism
//
//  Created by 酒井ゆうき on 2020/07/09.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit

class PopupViewController : UIViewController {
    
    var request : Request?
    let sampleBtn = UIButton()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .red
        
        self.sampleBtn.frame = CGRect(x: 100, y: 100, width: 100, height: 100)
        self.sampleBtn.backgroundColor = UIColor.red
        self.sampleBtn.setTitle("button", for: .normal)
        self.sampleBtn.addTarget(
          self,
          action: #selector(self.btnTapped(sender:)),
          for: .touchUpInside
        )

        self.view.addSubview(self.sampleBtn)
    }
   
    @objc func btnTapped(sender : UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
    

