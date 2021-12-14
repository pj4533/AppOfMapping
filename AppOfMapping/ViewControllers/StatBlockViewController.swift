//
//  StatBlockViewController.swift
//  Slaad
//
//  Created by PJ Gray on 5/21/19.
//  Copyright © 2019 Say Goodnight. All rights reserved.
//

import UIKit

class StatBlockViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var monster : Monster?
    
    enum StatBlockRow : Int, CaseIterable {
        case name = 0
        case typeSubtypeAlignment = 1
        case armorClass = 2
        case hitPoints = 3
        case speed = 4
        case saves = 5
        case skills = 6
        case damageVulnerable = 7
        case damageImmune = 8
        case damageResist = 9
        case conditionImmune = 10
        case senses = 11
        case languages = 12
        case challenge = 13
        case stats = 14
        case taperedLine = 15
        case abilities = 16
        case actionsLabel = 17
        case actions = 18
        case legendaryActionsLabel = 19
        case legendaryActions = 20
    }
    
    var rows : [StatBlockRow] = []
    
    @IBOutlet weak var tableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Stat Block"
        self.tableview.rowHeight = UITableView.automaticDimension
        self.tableview.contentInset = UIEdgeInsets(top: 16.0, left: 0.0, bottom: 0.0, right: 0.0)
        self.rows = [
            .name,
            .typeSubtypeAlignment,
            .taperedLine,
            .armorClass,
            .hitPoints,
            .speed,
            .taperedLine,
            .stats,
            .taperedLine
        ]
        
        if self.monster?.hasAnySavingThrows() ?? false {
            self.rows.append(.saves)
        }
        if self.monster?.hasAnySkills() ?? false {
            self.rows.append(.skills)
        }
        if let value = self.monster?.damageVulnerabilities, value.count > 0 {
            self.rows.append(.damageVulnerable)
        }
        if let value = self.monster?.damageResistances, value.count > 0 {
            self.rows.append(.damageResist)
        }
        if let value = self.monster?.damageImmunities, value.count > 0 {
            self.rows.append(.damageImmune)
        }
        if let value = self.monster?.conditionImmunities, value.count > 0 {
            self.rows.append(.conditionImmune)
        }
        if let value = self.monster?.senses, value.count > 0 {
            self.rows.append(.senses)
        }
        if let value = self.monster?.languages, value.count > 0 {
            self.rows.append(.languages)
        }
        
        self.rows.append(.challenge)
        self.rows.append(.taperedLine)
        
        if self.monster?.specialAbilities?.count ?? 0 > 0 {
            self.rows.append(.abilities)
        }
        
        self.rows.append(.actionsLabel)
        self.rows.append(.actions)
        if self.monster?.legendaryActions?.count ?? 0 > 0 {
            self.rows.append(.legendaryActionsLabel)
            self.rows.append(.legendaryActions)
        }
    }
    
    // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = self.rows[indexPath.row]

        if row == StatBlockRow.taperedLine {
            let cell = tableView.dequeueReusableCell(withIdentifier: "taperedLineCell", for: indexPath)
            return cell
        } else if row == StatBlockRow.stats {
            let cell = tableView.dequeueReusableCell(withIdentifier: "statsCell", for: indexPath)
            if let cell = cell as? StatsTableViewCell {
                var fontSize : CGFloat = 16.0
                if self.traitCollection.horizontalSizeClass == .compact {
                    fontSize = 14.0
                }
                
                cell.strLabel.font = UIFont(name: "GillSans-SemiBold", size: fontSize)!
                cell.strLabel.textColor = UIColor.fromHex(0x7A200D)
                cell.strLabel.text = "STR"
                cell.strValueLabel.font = UIFont(name: "GillSans", size: fontSize)!
                cell.strValueLabel.textColor = UIColor.fromHex(0x7A200D)
                cell.strValueLabel.text = "\(self.monster?.strength ?? 0) (\(self.monster?.strModifier() ?? 0 >= 0 ? "+" : "")\(self.monster?.strModifier() ?? 0))"
                cell.dexLabel.font = UIFont(name: "GillSans-SemiBold", size: fontSize)!
                cell.dexLabel.textColor = UIColor.fromHex(0x7A200D)
                cell.dexLabel.text = "DEX"
                cell.dexValueLabel.font = UIFont(name: "GillSans", size: fontSize)!
                cell.dexValueLabel.textColor = UIColor.fromHex(0x7A200D)
                cell.dexValueLabel.text = "\(self.monster?.dexterity ?? 0) (\(self.monster?.dexModifier() ?? 0 >= 0 ? "+" : "")\(self.monster?.dexModifier() ?? 0))"
                cell.conLabel.font = UIFont(name: "GillSans-SemiBold", size: fontSize)!
                cell.conLabel.textColor = UIColor.fromHex(0x7A200D)
                cell.conLabel.text = "CON"
                cell.conValueLabel.font = UIFont(name: "GillSans", size: fontSize)!
                cell.conValueLabel.textColor = UIColor.fromHex(0x7A200D)
                cell.conValueLabel.text = "\(self.monster?.constitution ?? 0) (\(self.monster?.conModifier() ?? 0 >= 0 ? "+" : "")\(self.monster?.conModifier() ?? 0))"
                cell.intLabel.font = UIFont(name: "GillSans-SemiBold", size: fontSize)!
                cell.intLabel.textColor = UIColor.fromHex(0x7A200D)
                cell.intLabel.text = "INT"
                cell.intValueLabel.font = UIFont(name: "GillSans", size: fontSize)!
                cell.intValueLabel.textColor = UIColor.fromHex(0x7A200D)
                cell.intValueLabel.text = "\(self.monster?.intelligence ?? 0) (\(self.monster?.intModifier() ?? 0 >= 0 ? "+" : "")\(self.monster?.intModifier() ?? 0))"
                cell.wisLabel.font = UIFont(name: "GillSans-SemiBold", size: fontSize)!
                cell.wisLabel.textColor = UIColor.fromHex(0x7A200D)
                cell.wisLabel.text = "WIS"
                cell.wisValueLabel.font = UIFont(name: "GillSans", size: fontSize)!
                cell.wisValueLabel.textColor = UIColor.fromHex(0x7A200D)
                cell.wisValueLabel.text = "\(self.monster?.wisdom ?? 0) (\(self.monster?.wisModifier() ?? 0 >= 0 ? "+" : "")\(self.monster?.wisModifier() ?? 0))"
                cell.chaLabel.font = UIFont(name: "GillSans-SemiBold", size: fontSize)!
                cell.chaLabel.textColor = UIColor.fromHex(0x7A200D)
                cell.chaLabel.text = "CHA"
                cell.chaValueLabel.font = UIFont(name: "GillSans", size: fontSize)!
                cell.chaValueLabel.textColor = UIColor.fromHex(0x7A200D)
                cell.chaValueLabel.text = "\(self.monster?.charisma ?? 0) (\(self.monster?.chaModifier() ?? 0 >= 0 ? "+" : "")\(self.monster?.chaModifier() ?? 0))"
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            if let cell = cell as? LabelTableViewCell {
                cell.lineView.isHidden = true
                if row == StatBlockRow.legendaryActions {
                    var desc = ""
                    if let legendaryDesc = self.monster?.legendaryDesc {
                        desc = "\n\(legendaryDesc)\n\n"
                    }
                    let attrString = NSMutableAttributedString(string: desc, attributes: [
                        NSAttributedString.Key.foregroundColor : UIColor.black,
                        NSAttributedString.Key.font: UIFont(name: "GillSans", size: 16.0)!
                        ])
                    for action in self.monster?.legendaryActions ?? []  {
                        attrString.append(NSAttributedString(string: "\(action.name ?? ""). ", attributes: [
                            NSAttributedString.Key.foregroundColor : UIColor.black,
                            NSAttributedString.Key.font: UIFont(name: "GillSans-SemiBold", size: 16.0)!
                            ]))
                        attrString.append(NSAttributedString(string: " \(action.desc ?? "")\n", attributes: [
                            NSAttributedString.Key.foregroundColor : UIColor.black,
                            NSAttributedString.Key.font: UIFont(name: "GillSans", size: 16.0)!
                            ]))
                    }
                    cell.customLabel?.attributedText = attrString
                } else if row == StatBlockRow.actions {
                    let attrString = NSMutableAttributedString(string: "")
                    for action in self.monster?.actions ?? []  {
                        attrString.append(NSAttributedString(string: "\n"))
                        attrString.append(NSAttributedString(string: "\(action.name ?? ""). ", attributes: [
                            NSAttributedString.Key.foregroundColor : UIColor.black,
                            NSAttributedString.Key.font: UIFont(name: "GillSans-SemiBoldItalic", size: 16.0)!
                            ]))
                        attrString.append(NSAttributedString(string: " \(action.desc ?? "")\n", attributes: [
                            NSAttributedString.Key.foregroundColor : UIColor.black,
                            NSAttributedString.Key.font: UIFont(name: "GillSans", size: 16.0)!
                            ]))
                    }
                    cell.customLabel?.attributedText = attrString
                } else if row == StatBlockRow.actionsLabel || row == StatBlockRow.legendaryActionsLabel {
                    if let baskerville = UIFont(name: "AvenirNext-Regular", size: 24) {
                        let smallCapsDesc = baskerville.fontDescriptor.addingAttributes([
                            UIFontDescriptor.AttributeName.featureSettings: [
                                [
                                    UIFontDescriptor.FeatureKey.featureIdentifier: kLowerCaseType,
                                    UIFontDescriptor.FeatureKey.typeIdentifier: kLowerCaseSmallCapsSelector
                                ]
                            ]
                            ])
                        cell.customLabel?.font = UIFont(descriptor: smallCapsDesc, size: baskerville.pointSize)
                        cell.customLabel?.textColor = UIColor.fromHex(0x7A200D)
                        cell.customLabel?.text = row == StatBlockRow.actionsLabel ? "Actions" : "Legendary Actions"
                        cell.lineView.isHidden = false
                        cell.lineView.backgroundColor = UIColor.fromHex(0x7A200D)
                        cell.clipsToBounds = false
                    }
                } else if row == StatBlockRow.abilities {
                    let attrString = NSMutableAttributedString(string: "")
                    for ability in self.monster?.specialAbilities ?? []  {
                        attrString.append(NSAttributedString(string: "\n"))
                        attrString.append(NSAttributedString(string: "\(ability.name ?? ""). ", attributes: [
                            NSAttributedString.Key.foregroundColor : UIColor.black,
                            NSAttributedString.Key.font: UIFont(name: "GillSans-SemiBoldItalic", size: 16.0)!
                            ]))
                        attrString.append(NSAttributedString(string: " \(ability.desc ?? "")\n", attributes: [
                            NSAttributedString.Key.foregroundColor : UIColor.black,
                            NSAttributedString.Key.font: UIFont(name: "GillSans", size: 16.0)!
                            ]))
                    }
                    cell.customLabel?.attributedText = attrString
                } else if row == StatBlockRow.name {
                    if let baskerville = UIFont(name: "Baskerville", size: 27) {
                        let smallCapsDesc = baskerville.fontDescriptor.addingAttributes([
                            UIFontDescriptor.AttributeName.featureSettings: [
                                [
                                    UIFontDescriptor.FeatureKey.featureIdentifier: kLowerCaseType,
                                    UIFontDescriptor.FeatureKey.typeIdentifier: kUpperCaseSmallCapsSelector
                                ]
                            ]
                            ])
                        cell.customLabel?.font = UIFont(descriptor: smallCapsDesc, size: baskerville.pointSize)
                        cell.customLabel?.textColor = UIColor.fromHex(0x7A200D)
                        cell.customLabel?.text = self.monster?.name?.capitalized
                    }
                } else if row == StatBlockRow.typeSubtypeAlignment {
                    if let font = UIFont(name: "GillSans-Italic", size: 16.0) {
                        cell.customLabel?.font = font
                        cell.customLabel?.textColor = UIColor.black
                        var descString = "\(self.monster?.size?.capitalized ?? "") \(self.monster?.type?.lowercased() ?? "")"
                        if (self.monster?.subtype != nil) && ((self.monster?.subtype?.count ?? 0) > 0) {
                            descString = "\(descString) (\(self.monster?.subtype?.lowercased() ?? ""))"
                        }
                        descString = "\(descString), \(self.monster?.alignment?.lowercased() ?? "")"
                        cell.customLabel?.text = descString
                    }
                } else if row == StatBlockRow.armorClass {
                    let attrString = NSMutableAttributedString(string: "")
                    attrString.append(NSAttributedString(string: "Armor Class", attributes: [
                        NSAttributedString.Key.foregroundColor : UIColor.fromHex(0x7A200D),
                        NSAttributedString.Key.font: UIFont(name: "GillSans-SemiBold", size: 16.0)!
                        ]))
                    attrString.append(NSAttributedString(string: " \(self.monster?.armorClass ?? 0)", attributes: [
                        NSAttributedString.Key.foregroundColor : UIColor.fromHex(0x7A200D),
                        NSAttributedString.Key.font: UIFont(name: "GillSans", size: 16.0)!
                        ]))
                    if let armorDesc = self.monster?.armorDesc, armorDesc.count > 0 {
                        attrString.append(NSAttributedString(string: " (\(armorDesc))", attributes: [
                            NSAttributedString.Key.foregroundColor : UIColor.fromHex(0x7A200D),
                            NSAttributedString.Key.font: UIFont(name: "GillSans", size: 16.0)!
                            ]))
                    }
                    cell.customLabel?.attributedText = attrString
                } else if row == StatBlockRow.hitPoints {
                    let attrString = NSMutableAttributedString(string: "")
                    attrString.append(NSAttributedString(string: "Hit Points", attributes: [
                        NSAttributedString.Key.foregroundColor : UIColor.fromHex(0x7A200D),
                        NSAttributedString.Key.font: UIFont(name: "GillSans-SemiBold", size: 16.0)!
                        ]))
                    attrString.append(NSAttributedString(string: " \(self.monster?.hitPoints ?? 0)", attributes: [
                        NSAttributedString.Key.foregroundColor : UIColor.fromHex(0x7A200D),
                        NSAttributedString.Key.font: UIFont(name: "GillSans", size: 16.0)!
                        ]))
                    if let hitdice = self.monster?.hitDice, hitdice.count > 0 {
                        attrString.append(NSAttributedString(string: " (\(hitdice))", attributes: [
                            NSAttributedString.Key.foregroundColor : UIColor.fromHex(0x7A200D),
                            NSAttributedString.Key.font: UIFont(name: "GillSans", size: 16.0)!
                            ]))
                    }
                    cell.customLabel?.attributedText = attrString
                } else if row == StatBlockRow.speed {
                    let attrString = NSMutableAttributedString(string: "")
                    attrString.append(NSAttributedString(string: "Speed ", attributes: [
                        NSAttributedString.Key.foregroundColor : UIColor.fromHex(0x7A200D),
                        NSAttributedString.Key.font: UIFont(name: "GillSans-SemiBold", size: 16.0)!
                        ]))
                    attrString.append(NSAttributedString(string: self.monster?.speed ?? "", attributes: [
                        NSAttributedString.Key.foregroundColor : UIColor.fromHex(0x7A200D),
                        NSAttributedString.Key.font: UIFont(name: "GillSans", size: 16.0)!
                        ]))
                    cell.customLabel?.attributedText = attrString
                } else if row == StatBlockRow.saves {
                    let attrString = NSMutableAttributedString(string: "")
                    attrString.append(NSAttributedString(string: "Saving Throws ", attributes: [
                        NSAttributedString.Key.foregroundColor : UIColor.fromHex(0x7A200D),
                        NSAttributedString.Key.font: UIFont(name: "GillSans-SemiBold", size: 16.0)!
                        ]))
                    var savingThrows : [String] = []
                    if let saveValue = self.monster?.strengthSave { savingThrows.append("Str +\(saveValue)") }
                    if let saveValue = self.monster?.dexteritySave { savingThrows.append("Dex +\(saveValue)") }
                    if let saveValue = self.monster?.constitutionSave { savingThrows.append("Con +\(saveValue)") }
                    if let saveValue = self.monster?.intelligenceSave { savingThrows.append("Int +\(saveValue)") }
                    if let saveValue = self.monster?.wisdomSave { savingThrows.append("Wis +\(saveValue)") }
                    if let saveValue = self.monster?.charismaSave { savingThrows.append("Cha +\(saveValue)") }
                    attrString.append(NSAttributedString(string: savingThrows.joined(separator: ", "), attributes: [
                        NSAttributedString.Key.foregroundColor : UIColor.fromHex(0x7A200D),
                        NSAttributedString.Key.font: UIFont(name: "GillSans", size: 16.0)!
                        ]))
                    cell.customLabel?.attributedText = attrString
                } else if row == StatBlockRow.skills {
                    let attrString = NSMutableAttributedString(string: "")
                    attrString.append(NSAttributedString(string: "Skills ", attributes: [
                        NSAttributedString.Key.foregroundColor : UIColor.fromHex(0x7A200D),
                        NSAttributedString.Key.font: UIFont(name: "GillSans-SemiBold", size: 16.0)!
                        ]))
                    var skills : [String] = []
                    if let skillValue = self.monster?.athletics { skills.append("Athletics +\(skillValue)") }
                    if let skillValue = self.monster?.acrobatics { skills.append("Acrobatics +\(skillValue)") }
                    if let skillValue = self.monster?.sleightOfHand { skills.append("Sleight Of Hand +\(skillValue)") }
                    if let skillValue = self.monster?.stealth { skills.append("Stealth +\(skillValue)") }
                    if let skillValue = self.monster?.arcana { skills.append("Arcana +\(skillValue)") }
                    if let skillValue = self.monster?.history { skills.append("History +\(skillValue)") }
                    if let skillValue = self.monster?.investigation { skills.append("Investigation +\(skillValue)") }
                    if let skillValue = self.monster?.nature { skills.append("Nature +\(skillValue)") }
                    if let skillValue = self.monster?.religion { skills.append("Religion +\(skillValue)") }
                    if let skillValue = self.monster?.animalHandling { skills.append("Animal Handling +\(skillValue)") }
                    if let skillValue = self.monster?.insight { skills.append("Insight +\(skillValue)") }
                    if let skillValue = self.monster?.medicine { skills.append("Medicine +\(skillValue)") }
                    if let skillValue = self.monster?.perception { skills.append("Perception +\(skillValue)") }
                    if let skillValue = self.monster?.survival { skills.append("Survival +\(skillValue)") }
                    if let skillValue = self.monster?.deception { skills.append("Deception +\(skillValue)") }
                    if let skillValue = self.monster?.intimidation { skills.append("Intimidation +\(skillValue)") }
                    if let skillValue = self.monster?.performance { skills.append("Performance +\(skillValue)") }
                    if let skillValue = self.monster?.persuasion { skills.append("Persuasion +\(skillValue)") }
                    attrString.append(NSAttributedString(string: skills.joined(separator: ", "), attributes: [
                        NSAttributedString.Key.foregroundColor : UIColor.fromHex(0x7A200D),
                        NSAttributedString.Key.font: UIFont(name: "GillSans", size: 16.0)!
                        ]))
                    cell.customLabel?.attributedText = attrString
                } else if row == StatBlockRow.damageImmune {
                    let attrString = NSMutableAttributedString(string: "")
                    attrString.append(NSAttributedString(string: "Damage Immunities ", attributes: [
                        NSAttributedString.Key.foregroundColor : UIColor.fromHex(0x7A200D),
                        NSAttributedString.Key.font: UIFont(name: "GillSans-SemiBold", size: 16.0)!
                        ]))
                    attrString.append(NSAttributedString(string: self.monster?.damageImmunities ?? "", attributes: [
                        NSAttributedString.Key.foregroundColor : UIColor.fromHex(0x7A200D),
                        NSAttributedString.Key.font: UIFont(name: "GillSans", size: 16.0)!
                        ]))
                    cell.customLabel?.attributedText = attrString
                } else if row == StatBlockRow.damageResist {
                    let attrString = NSMutableAttributedString(string: "")
                    attrString.append(NSAttributedString(string: "Damage Resistances ", attributes: [
                        NSAttributedString.Key.foregroundColor : UIColor.fromHex(0x7A200D),
                        NSAttributedString.Key.font: UIFont(name: "GillSans-SemiBold", size: 16.0)!
                        ]))
                    attrString.append(NSAttributedString(string: self.monster?.damageResistances ?? "", attributes: [
                        NSAttributedString.Key.foregroundColor : UIColor.fromHex(0x7A200D),
                        NSAttributedString.Key.font: UIFont(name: "GillSans", size: 16.0)!
                        ]))
                    cell.customLabel?.attributedText = attrString
                } else if row == StatBlockRow.damageVulnerable {
                    let attrString = NSMutableAttributedString(string: "")
                    attrString.append(NSAttributedString(string: "Damage Vulnerabilities ", attributes: [
                        NSAttributedString.Key.foregroundColor : UIColor.fromHex(0x7A200D),
                        NSAttributedString.Key.font: UIFont(name: "GillSans-SemiBold", size: 16.0)!
                        ]))
                    attrString.append(NSAttributedString(string: self.monster?.damageVulnerabilities ?? "", attributes: [
                        NSAttributedString.Key.foregroundColor : UIColor.fromHex(0x7A200D),
                        NSAttributedString.Key.font: UIFont(name: "GillSans", size: 16.0)!
                        ]))
                    cell.customLabel?.attributedText = attrString
                } else if row == StatBlockRow.conditionImmune {
                    let attrString = NSMutableAttributedString(string: "")
                    attrString.append(NSAttributedString(string: "Condition Immunities ", attributes: [
                        NSAttributedString.Key.foregroundColor : UIColor.fromHex(0x7A200D),
                        NSAttributedString.Key.font: UIFont(name: "GillSans-SemiBold", size: 16.0)!
                        ]))
                    attrString.append(NSAttributedString(string: self.monster?.conditionImmunities ?? "", attributes: [
                        NSAttributedString.Key.foregroundColor : UIColor.fromHex(0x7A200D),
                        NSAttributedString.Key.font: UIFont(name: "GillSans", size: 16.0)!
                        ]))
                    cell.customLabel?.attributedText = attrString
                } else if row == StatBlockRow.senses {
                    let attrString = NSMutableAttributedString(string: "")
                    attrString.append(NSAttributedString(string: "Senses ", attributes: [
                        NSAttributedString.Key.foregroundColor : UIColor.fromHex(0x7A200D),
                        NSAttributedString.Key.font: UIFont(name: "GillSans-SemiBold", size: 16.0)!
                        ]))
                    attrString.append(NSAttributedString(string: self.monster?.senses ?? "", attributes: [
                        NSAttributedString.Key.foregroundColor : UIColor.fromHex(0x7A200D),
                        NSAttributedString.Key.font: UIFont(name: "GillSans", size: 16.0)!
                        ]))
                    cell.customLabel?.attributedText = attrString
                } else if row == StatBlockRow.languages {
                    let attrString = NSMutableAttributedString(string: "")
                    attrString.append(NSAttributedString(string: "Languages ", attributes: [
                        NSAttributedString.Key.foregroundColor : UIColor.fromHex(0x7A200D),
                        NSAttributedString.Key.font: UIFont(name: "GillSans-SemiBold", size: 16.0)!
                        ]))
                    attrString.append(NSAttributedString(string: self.monster?.languages ?? "", attributes: [
                        NSAttributedString.Key.foregroundColor : UIColor.fromHex(0x7A200D),
                        NSAttributedString.Key.font: UIFont(name: "GillSans", size: 16.0)!
                        ]))
                    cell.customLabel?.attributedText = attrString
                } else if row == StatBlockRow.challenge {
                    let attrString = NSMutableAttributedString(string: "")
                    attrString.append(NSAttributedString(string: "Challenge ", attributes: [
                        NSAttributedString.Key.foregroundColor : UIColor.fromHex(0x7A200D),
                        NSAttributedString.Key.font: UIFont(name: "GillSans-SemiBold", size: 16.0)!
                        ]))
                    let numberFormatter = NumberFormatter()
                    numberFormatter.numberStyle = .decimal
                    let formattedNumber = numberFormatter.string(from: NSNumber(value:self.monster?.experiencePoints() ?? 0))
                    let challengeString = "\(self.monster?.challengeRating ?? "") (\(formattedNumber ?? "") XP)"
                    attrString.append(NSAttributedString(string: challengeString, attributes: [
                        NSAttributedString.Key.foregroundColor : UIColor.fromHex(0x7A200D),
                        NSAttributedString.Key.font: UIFont(name: "GillSans", size: 16.0)!
                        ]))
                    cell.customLabel?.attributedText = attrString
                }
                
            }
            return cell
        }
    }

}
