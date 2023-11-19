//
//  ViewController.swift
//  BlaBlaBla
//
//  Created by Mateus Rodrigues on 15/11/23.
//

import UIKit
import SwiftUI

struct Representable<Content: UIView>: UIViewRepresentable {
    
    let content: () -> Content

    func makeUIView(context: Context) -> Content {
        content()
    }
    
    func updateUIView(_ uiView: Content, context: Context) {
        
    }
    
}

struct RepresentableViewController<ViewController: UIViewController>: UIViewControllerRepresentable {
    let builder: () -> ViewController

    init(_ builder: @escaping () -> ViewController) {
        self.builder = builder
    }

    func makeUIViewController(context: Context) -> ViewController {
        builder()
    }

    func updateUIViewController(_ uiViewController: ViewController, context: Context) {
        return
    }
}

extension UIButton {
    
    func configure(_ handler: (inout UIButton.Configuration) -> Void) {
        var configuration = self.configuration ?? UIButton.Configuration.borderless()
        handler(&configuration)
        self.configuration = configuration
    }
    
}

class ViewController: UIViewController, UICollectionViewDataSource {

        
    let collectionView: UICollectionView = {
        let provider = { (_: Int, layoutEnv: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
            configuration.footerMode = .supplementary
            
            // Hide bottom separator for first item in each section
//            configuration.itemSeparatorHandler = { indexPath, sectionSeparatorConfiguration in
//                var configuration = sectionSeparatorConfiguration
//                configuration.bottomSeparatorVisibility = indexPath.row.isMultiple(of: 2) ? .hidden : .visible
//                return configuration
//            }

            return .list(using: configuration, layoutEnvironment: layoutEnv)
        }
        let listLayout = UICollectionViewCompositionalLayout(sectionProvider: provider)
        return UICollectionView(frame: .zero, collectionViewLayout: listLayout)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(collectionView)
        
        collectionView.register(UICollectionViewListCell.self, forCellWithReuseIdentifier: "cell")
        
        collectionView.frame = view.frame
        
        collectionView.dataSource = self
       
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 50
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! UICollectionViewListCell
        cell.backgroundConfiguration?.backgroundColor = .systemYellow
        cell.indentationWidth = 0
        cell.indentationLevel = 0
        cell.contentConfiguration = UIHostingConfiguration {
            Text("Lorme Ipsum")
                .frame(maxWidth: .infinity)
                .background(.red)
        }
        .margins(.all, 0)
        return cell
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

#Preview {
    ViewController()
}
