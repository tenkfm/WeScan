//
//  ImageCropController.swift
//  WeScan
//
//  Created by Anton Rogachevskyi on 21/05/2019.
//  Copyright © 2019 WeTransfer. All rights reserved.
//

import UIKit
import AVFoundation

public protocol ImageCropControllerDelegate: NSObjectProtocol {
    
    func imageCropController(_ scanner: ImageCropController, didFinishCroppingWithResults results: ImageCropResults)
    
    /// Tells the delegate that the user cancelled the scan operation.
    ///
    /// - Parameters:
    ///   - scanner: The scanner controller object managing the scanning interface.
    /// - Discussion: Your delegate's implementation of this method should dismiss the image scanner controller.
    func imageCropControllerDidCancel(_ scanner: ImageCropController)
    
    func imageCropController(_ scanner: ImageCropController, didFailWithError error: Error)
}

/// A view controller that manages the full flow for scanning documents.
/// The `ImageScannerController` class is meant to be presented. It consists of a series of 3 different screens which guide the user:
/// 1. Uses the camera to capture an image with a rectangle that has been detected.
/// 2. Edit the detected rectangle.
/// 3. Review the cropped down version of the rectangle.
public final class ImageCropController: UINavigationController {
    
    /// The object that acts as the delegate of the `ImageCropController`.
    weak public var imageCropDelegate: ImageCropControllerDelegate?
    
    public var navigationBarTint: UIColor = .black
    public var navigationBarBackground: UIColor = .white
    
    // MARK: - Life Cycle
    
    public required init(picture: UIImage) {
        let quad = Quadrilateral(topLeft: CGPoint(x: 0, y: 0),
                                 topRight: CGPoint(x: picture.size.width, y: 0),
                                 bottomRight: CGPoint(x: picture.size.width, y: picture.size.height),
                                 bottomLeft: CGPoint(x: 0, y: picture.size.height))
        
        let cropViewController = EditScanViewController(image: picture, quad: quad)
        cropViewController.showBackButton = true
        super.init(rootViewController: cropViewController)
        navigationBar.tintColor = .black
        navigationBar.isTranslucent = false
        self.view.backgroundColor = .black
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
}

/// Data structure containing information about a scan.
public struct ImageCropResults {
    
    /// The original image taken by the user, prior to the cropping applied by WeScan.
    public var originalImage: UIImage
    
    /// The deskewed and cropped orignal image using the detected rectangle, without any filters.
    public var scannedImage: UIImage
    
    /// The enhanced image, passed through an Adaptive Thresholding function. This image will always be grayscale and may not always be available.
    public var enhancedImage: UIImage?
    
    /// Whether the user wants to use the enhanced image or not. The `enhancedImage`, for use with OCR or similar uses, may still be available even if it has not been selected by the user.
    public var doesUserPreferEnhancedImage: Bool
    
    /// The detected rectangle which was used to generate the `scannedImage`.
    public var detectedRectangle: Quadrilateral
    
}

