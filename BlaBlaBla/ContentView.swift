//
//  ContentView.swift
//  BlaBlaBla
//
//  Created by Mateus Rodrigues on 15/11/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            
            Button("Lorem Ipsum") {
                
            }
            .font(.title)
            .fontWeight(.ultraLight)
//            .fontDesign(.serif)
            .italic()
            .tint(.yellow)
            .foregroundStyle(.red)
            .controlSize(.large)
            .buttonBorderShape(.capsule)
            .strikethrough(pattern: .dash, color: .blue)
            .overlay {
                Rectangle()
                    .stroke(.black)
                    .frame(height: 300)
            }
            Representable {
                
                let label = UILabel()
                

                
                var attributedTitle = AttributedString("Lorem Ipsum")
                
                attributedTitle.foregroundColor = .systemRed
                attributedTitle.strikethroughStyle = .single.union(.patternDash)
                attributedTitle.strikethroughColor = .systemBlue
                attributedTitle.underlineStyle = NSUnderlineStyle.single
                attributedTitle.font = UIFont.preferredFont(forTextStyle: .title1)
                
                let string = "Attributed String"
                let attributes: [NSAttributedString.Key : Any] = [
                    .foregroundColor: UIColor.red,
                    .strikethroughStyle: NSUnderlineStyle.patternDash.rawValue | NSUnderlineStyle.single.rawValue,
                    .strikethroughColor: UIColor.systemBlue,
                    .font: UIFont.preferredFont(forTextStyle: .title1)

                ]
                let attributedString = NSAttributedString(string: string, attributes: attributes)
                
                label.attributedText = NSAttributedString(attributedTitle)
                
                return label
                
            }
            .fixedSize()
            Representable {
                
                let button = UIButton()
                
                var configuration = UIButton.Configuration.borderedProminent()
                
                
                configuration.title =  "Lorem Ipsum"
                configuration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
                    var outgoing = incoming
                    outgoing.strikethroughStyle = .single
                    outgoing.strikethroughColor = .blue
                    outgoing.underlineColor = .cyan
                    outgoing.underlineStyle = .single
                    outgoing.font = UIFont.preferredFont(for: .title1, weight: .ultraLight, width: .standard, design: .serif, symbolic: .traitItalic)
                    return outgoing
                }
                
                configuration.background.visualEffect = UIBlurEffect(style: .systemThinMaterial)
                configuration.baseBackgroundColor = .clear
                configuration.background.visualEffect = UIBlurEffect(style: .systemThinMaterial)
                configuration.baseForegroundColor = .systemRed
//                configuration.buttonSize = .large
                
                print(configuration.contentInsets)
//                print(configuration.background.cornerRadius)
//
                button.configuration = configuration
                
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    print(button.subviews.map(\.layer.cornerRadius))
                }
                
                return button
                
            }
            .fixedSize()
        }
        .buttonStyle(.borderedProminent)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            Image("windows-xp")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea(edges: .all)
        }
    }
}

#Preview {
    ContentView()
}

extension UIFont {
    static func preferredFont(for textStyle: TextStyle, weight: Weight, width: Width, design: UIFontDescriptor.SystemDesign, symbolic: UIFontDescriptor.SymbolicTraits) -> UIFont {
        
        var traits: [UIFontDescriptor.TraitKey: Any] = [:]
        
        traits[.weight] = weight.rawValue
        traits[.width] = width.rawValue
        traits[.symbolic] = symbolic.rawValue
        
        var attributes: [UIFontDescriptor.AttributeName : Any] = [:]
        
        attributes[.textStyle] = textStyle
        attributes[.traits] = traits
        
        var descriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: textStyle)
        
        descriptor = descriptor.addingAttributes(attributes)
        
        descriptor = descriptor.withDesign(design) ?? descriptor
           
        return UIFont(descriptor: descriptor, size: 0)
    }
}
