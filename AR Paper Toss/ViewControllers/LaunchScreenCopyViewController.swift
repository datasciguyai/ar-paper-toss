//
//  LaunchScreenCopyViewController.swift
//  AR Paper Toss
//
//  Created by Johnny Hicks on 11/9/17.
//  Copyright © 2017 Jeremy Reynolds. All rights reserved.
//

import UIKit

class LaunchScreenCopyViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { (_) in
            self.performSegue(withIdentifier: "toMainScreen", sender: nil)
        }

        // Do any additional setup after loading the view.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
