// CardsViewController.swift

import UIKit

class CardsViewController: UITableViewController, UIColorPickerViewControllerDelegate {

    var newCardText: String!
    var newCardColor: UIColor!

    weak var rootVC: ViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Cards"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addCardAlert))
    }

    @objc func addCardAlert() {
        let ac = UIAlertController(title: "Add Card", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Submit", style: .cancel) { [weak self] _ in
            if let text = ac.textFields?.first?.text {
                self?.addCard()
                self?.newCardText = text
            }
        })
        present(ac, animated: true)
    }

    func addCard() {
        let vc = UIColorPickerViewController()
        vc.delegate = self
        present(vc, animated: true)
    }

    func colorPickerViewController(_ viewController: UIColorPickerViewController, didSelect color: UIColor, continuously: Bool) {
        newCardColor = color
    }

    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        let newCard = Card(name: newCardText, color: Color(uiColor: newCardColor))
        rootVC.possibleCards.append(newCard)
        rootVC.save()
        rootVC.restart()
        tableView.reloadData()
    }

    // MARK: - TableView source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rootVC.possibleCards.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as? TableViewCell else { fatalError("Failed to get table view cell") }
        
        let card = rootVC.possibleCards[indexPath.row]

        cell.colorView.backgroundColor = card.color.uiColor
        cell.label.text = card.name

        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            rootVC.possibleCards.remove(at: indexPath.row)
            rootVC.save()
            rootVC.restart()
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
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
