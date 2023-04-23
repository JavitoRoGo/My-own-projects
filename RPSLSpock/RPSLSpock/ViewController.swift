//
//  ViewController.swift
//  RPSLSpock
//
//  Created by Javier Rodríguez Gómez on 21/3/21.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet var generalView: UIView!
    @IBOutlet weak var winsLabel: UILabel!
    @IBOutlet weak var losesLabel: UILabel!
    @IBOutlet weak var tiesLabel: UILabel!
    @IBOutlet weak var playsLabel: UILabel!
    @IBOutlet weak var appSign: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var rockSign: UIButton!
    @IBOutlet weak var paperSign: UIButton!
    @IBOutlet weak var scisorSign: UIButton!
    @IBOutlet weak var lizzardSign: UIButton!
    @IBOutlet weak var spockSign: UIButton!
    @IBOutlet weak var resultEmojiLabel: UILabel!
    @IBOutlet weak var playAgain: UIButton!
    
    // MARK: - Counters
    
    var numberOfWins: Int = 0 {
        didSet {
            winsLabel.text = "\(numberOfWins)"
        }
    }
    var numberOfLoses: Int = 0 {
        didSet {
            losesLabel.text = "\(numberOfLoses)"
        }
    }
    var numberOfTies: Int = 0 {
        didSet {
            tiesLabel.text = "\(numberOfTies)"
        }
    }
    var numberOfPlays: Int = 0 {
        didSet {
            playsLabel.text = "\(numberOfPlays)"
        }
    }
    
    // MARK: - UI

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(resetAlert))
        
        // Cargar los valores de la partida anterior
        numberOfWins = UserDefaults.standard.integer(forKey: "wins")
        numberOfLoses = UserDefaults.standard.integer(forKey: "loses")
        numberOfTies = UserDefaults.standard.integer(forKey: "ties")
        numberOfPlays = UserDefaults.standard.integer(forKey: "plays")

        restart()
    }

    // MARK: - Button Actions
    
    @IBAction func rockAction(_ sender: UIButton) {
        paperSign.isHidden = true
        scisorSign.isHidden = true
        lizzardSign.isHidden = true
        spockSign.isHidden = true
        play(.rock)
    }
    @IBAction func paperAction(_ sender: UIButton) {
        rockSign.isHidden = true
        scisorSign.isHidden = true
        lizzardSign.isHidden = true
        spockSign.isHidden = true
        play(.paper)
    }
    @IBAction func scisorAction(_ sender: UIButton) {
        rockSign.isHidden = true
        paperSign.isHidden = true
        lizzardSign.isHidden = true
        spockSign.isHidden = true
        play(.scisor)
    }
    @IBAction func lizzardAction(_ sender: UIButton) {
        rockSign.isHidden = true
        paperSign.isHidden = true
        scisorSign.isHidden = true
        spockSign.isHidden = true
        play(.lizzard)
    }
    @IBAction func spockAction(_ sender: UIButton) {
        rockSign.isHidden = true
        paperSign.isHidden = true
        scisorSign.isHidden = true
        lizzardSign.isHidden = true
        play(.spock)
    }
    
    @IBAction func playAgainAction(_ sender: UIButton) {
        restart()
    }
    
    // MARK: - Functions
    
    // VOLVER A JUGAR
    func restart() {
        generalView.backgroundColor = .white
        appSign.textColor = UIColor.red
        appSign.text = "?"
        resultLabel.text = "Elige tu seña"
        
        rockSign.isHidden = false
        paperSign.isHidden = false
        scisorSign.isHidden = false
        lizzardSign.isHidden = false
        spockSign.isHidden = false
        
        rockSign.isEnabled = true
        paperSign.isEnabled = true
        scisorSign.isEnabled = true
        lizzardSign.isEnabled = true
        spockSign.isEnabled = true
        
        resultEmojiLabel.isHidden = true
        playAgain.isHidden = true
    }
    
    // JUGAR
    func play(_ myPlay: Sign) {
        let otherPlay = randomSign()
        switch otherPlay {
        case .rock:
            appSign.text = "👊"
        case .paper:
            appSign.text = "✋"
        case .scisor:
            appSign.text = "✌️"
        case .lizzard:
            appSign.text = "🤏"
        case .spock:
            appSign.text = "🖖"
        }
        
        numberOfPlays += 1
        let result = gameState(mySign: myPlay, otherSign: otherPlay)
        switch result.state {
        case .win:
            generalView.backgroundColor = .green
            resultLabel.text = "¡Has ganado!\n\(result.text)"
            resultEmojiLabel.text = "🦖"
            numberOfWins += 1
        case .lose:
            generalView.backgroundColor = .red
            resultLabel.text = "¡Has perdido!\n\(result.text)"
            resultEmojiLabel.text = "💀"
            numberOfLoses += 1
        case .tie:
            generalView.backgroundColor = .yellow
            resultLabel.text = "Empate"
            resultEmojiLabel.text = "🐞"
            numberOfTies += 1
        }
        
        resultEmojiLabel.isHidden = false
        playAgain.isHidden = false
        rockSign.isEnabled = false
        paperSign.isEnabled = false
        scisorSign.isEnabled = false
        lizzardSign.isEnabled = false
        spockSign.isEnabled = false
        
        // Almacenar los valores al cerrar la aplicación
        UserDefaults.standard.set(numberOfWins, forKey: "wins")
        UserDefaults.standard.set(numberOfLoses, forKey: "loses")
        UserDefaults.standard.set(numberOfTies, forKey: "ties")
        UserDefaults.standard.set(numberOfPlays, forKey: "plays")
        
    }
    
    // BORRAR LOS CONTADORES
    func countersToZero() {
        numberOfWins = 0
        numberOfLoses = 0
        numberOfTies = 0
        numberOfPlays = 0
    }
    @objc func resetAlert() {
        // Alerta de borrado
        let alert = UIAlertController(title: "Restablecer los contadores", message: "Esto borrará los datos. ¿Estás seguro?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Borrar", style: .destructive, handler: {
                action in self.countersToZero()
            }))
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        // Por defecto el botón .cancel se muestra siempre primero
        present(alert, animated: true)
    }
    
}

