//
//  ViewController.swift
//  Nudity
//
//  Created by Philipp Gabriel on 01.10.17.
//  Copyright © 2017 Philipp Gabriel. All rights reserved.
//

import UIKit


class ViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var percentage: UILabel!
    let imagePicker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
       

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func loadImageButtonTapped(sender: UIButton) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            let model = Nudity()
            let size = CGSize(width: 224, height: 224)
            guard let buffer = pickedImage.resize(to: size)?.pixelBuffer() else {
                fatalError("Scaling or converting to pixel buffer failed!")
            }
            guard let result = try? model.prediction(data: buffer) else {
                fatalError("Prediction failed!")
            }
            let confidence = result.prob["\(result.classLabel)"]! * 100.0
            let converted = String(format: "%.2f", confidence)
            imageView.image = pickedImage
            percentage.text = "\(result.classLabel) = \(converted) %"
            if(result.classLabel == "SFW"){
                if(confidence < 50){
                    percentage.text = "*** Contains Nudity ***\(result.classLabel) = \(converted) %"

                }else{
                     percentage.text = "*** No Nudity Found ***\(result.classLabel) = \(converted) %"
                }
            }else{
                if(confidence > 70){
                    percentage.text = "*** Contains Nudity ***\(result.classLabel) = \(converted) %"
                    
                }else{
                    
                        percentage.text = "*** No Nudity Found ***\(result.classLabel) = \(converted) %"
                    
                }
            }
            /*
             if([topResult.identifier isEqualToString:@"SFW"]){
             if(percent < 50){
             NSLog(@"**** Contains Nudity");
             }
             }else{
             if(percent > 70){
             NSLog(@"**** Contains Nudity");
             }
             }
             
             */
        }
        dismiss(animated: true, completion: nil)
    }
    
    
}
