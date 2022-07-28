// ViewController.swift

import UIKit

class ViewController: UICollectionViewController {

    var firstSelectedCardItemIndex: Int? = nil
    var possibleCards = [Card]()
    var cards = [Card]()
    var exampleCards = [
        Card(name: "Apple", color: Color(uiColor: .red)),
        Card(name: "Banana", color: Color(uiColor: .yellow)),
        Card(name: "Orange", color: Color(uiColor: .orange)),
        Card(name: "Lime", color: Color(uiColor: .green)),
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Fruite Pairs"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cards", style: .plain, target: self, action: #selector(presentCardsVC))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Restart", style: .plain, target: self, action: #selector(restart))

        restart()

        collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }

    @objc func restart() {
        firstSelectedCardItemIndex = nil
        if let cells = collectionView.visibleCells as? [CollectionViewCell] {
            for cell in cells {
                cell.foreground.isHidden = false
                cell.foreground.backgroundColor = .white
            }
        }
        load()
        cards = [Card]()
        cards.append(contentsOf: possibleCards)
        cards.append(contentsOf: possibleCards)
        cards.shuffle()
        collectionView.reloadData()
    }

    @objc func presentCardsVC() {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Cards") as? CardsViewController {
            vc.rootVC = self
            navigationController?.pushViewController(vc, animated: true)
        }
    }

    // MARK: - CollectionView source

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cards.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as? CollectionViewCell else { fatalError("Failed to typecast a cell") }

        let card = cards[indexPath.item]

        cell.label.text = card.name
        cell.contentView.backgroundColor = card.color.uiColor
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.gray.cgColor

        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CollectionViewCell else { fatalError("Failed to get a cell") }
        
        let itemIndex = indexPath.item

        cell.foreground.isHidden = true

        if firstSelectedCardItemIndex == nil {
            return firstSelectedCardItemIndex = itemIndex
        }

        guard let firstSelectedCardCell = collectionView.cellForItem(at: IndexPath(item: self.firstSelectedCardItemIndex!, section: 0)) as? CollectionViewCell else { fatalError("Failed to get a cell") }

        if cards[firstSelectedCardItemIndex!] != cards[itemIndex] {
            self.firstSelectedCardItemIndex = nil
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                cell.foreground.isHidden = false
                firstSelectedCardCell.foreground.isHidden = false
            }
        } else {
            cell.foreground.isHidden = false
            firstSelectedCardCell.foreground.isHidden = false
            firstSelectedCardCell.foreground.backgroundColor = .black
            cell.foreground.backgroundColor = .black
            firstSelectedCardItemIndex = nil
        }

        if let cells = collectionView.visibleCells as? [CollectionViewCell] {
            for cell in cells {
                if cell.foreground.backgroundColor != .black {
                    return
                }
            }
            let ac = UIAlertController(title: "Congrats!", message: "You won, nice, try adding more cards!", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
                self?.restart()
            })
            present(ac, animated: true)
        }
    }

    // MARK: - Loading and Saving cards

    func load() {
        if let savedData = UserDefaults.standard.object(forKey: "cards") as? Data {
            do {
                let localCards = try JSONDecoder().decode([Card].self, from: savedData)
                if localCards.isEmpty {
                    possibleCards = exampleCards
                } else {
                    possibleCards = localCards
                }
            } catch {
                print("Failed to load saved cards. Error: \(error.localizedDescription)")
            }
        } else {
            possibleCards = exampleCards
            save()
        }
    }

    func save() {
        if let data = try? JSONEncoder().encode(possibleCards) {
            UserDefaults.standard.set(data, forKey: "cards")
        } else {
            print("Failed to encode cards")
        }
    }
}

