import UIKit

class ViewControllerCharacter: UIViewController {
    private let viewModel = CharactersViewModel()

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let header = UIView(frame: CGRect(x:0, y:0, width: view.frame.size.width, height: 50))
        let footer = UIView(frame: CGRect(x:0, y:0, width: view.frame.size.width, height: 20))
        
        let headerLabel = UILabel(frame: CGRect(x: 10, y: 10, width: header.frame.size.width - 20, height: 40))
        headerLabel.text = "Rick and Morty Characters"
        headerLabel.textAlignment = .center
        headerLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        headerLabel.textColor = .systemGreen
        headerLabel.shadowColor = .yellow
        headerLabel.shadowOffset = CGSize(width: 4, height: 4)
        header.addSubview(headerLabel)
        tableView.tableHeaderView = header
        
        let footerLabel = UILabel(frame: CGRect(x: 10, y: 10, width: header.frame.size.width - 20, height: 20))
        footerLabel.text = "By HuguitoDev"
        footerLabel.textAlignment = .center
        footerLabel.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        footerLabel.textColor = .systemGreen
        footerLabel.shadowColor = .yellow
        footerLabel.shadowOffset = CGSize(width: 4, height: 4)
        footer.addSubview(footerLabel)
        tableView.tableFooterView = footerLabel
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CharacterCell")
        
        viewModel.onUpdate = { [weak self] in
            self?.tableView.reloadData()
        }
        
        
        viewModel.fetchCharacters()
    }
    
    private func navigateToDetailViewController(with character: Character) {
        let detailViewController = ViewDetailController(nibName: "ViewDetailController", bundle: nil)
        detailViewController.characterId = character.id
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }

}



extension ViewControllerCharacter: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.characters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CharacterCell", for: indexPath)
        let character = viewModel.characters[indexPath.row]
        
        cell.textLabel?.text = character.name
        
        if let url = URL(string: character.image) {
            cell.imageView?.loadImage(from: url)
        } else {
            cell.imageView?.image = UIImage(systemName: "photo")
        }
        
        if let imageView = cell.imageView {
            imageView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                imageView.widthAnchor.constraint(equalToConstant: 100),
                imageView.heightAnchor.constraint(equalToConstant: 100),
                imageView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 10),
                imageView.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor)
            ])
        }
        
        if let textLabel = cell.textLabel {
            textLabel.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                textLabel.leadingAnchor.constraint(equalTo: cell.imageView!.trailingAnchor, constant: 10),
                textLabel.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -10),
                textLabel.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor)
            ])
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let character = viewModel.characters[indexPath.row]
        navigateToDetailViewController(with: character)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100 // Adjust this value to change the cell height
    }
    
    
}
