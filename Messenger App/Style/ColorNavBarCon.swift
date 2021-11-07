//
//  ColorNavBarCon.swift
//  Messenger App
//
//  Created by administrator on 07/11/2021.
//

import UIKit

class ColorNavBarCon: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    func gradientImage(withColours colours: [UIColor], location: [Double], view: UIView) -> UIImage {
    let gradient = CAGradientLayer()
    gradient.frame = view.bounds
    gradient.colors = colours.map { $0.cgColor }
    gradient.startPoint = (CGPoint(x: 0.0,y: 0.5), CGPoint(x: 1.0,y: 0.5)).0
    gradient.endPoint = (CGPoint(x: 0.0,y: 0.5), CGPoint(x: 1.0,y: 0.5)).1
    gradient.locations = location as [NSNumber]
    gradient.cornerRadius = view.layer.cornerRadius
    return UIImage.image(from: gradient) ?? UIImage()
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
