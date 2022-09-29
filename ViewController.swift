import UIKit

class ViewController: UIViewController {
		
   
    @IBOutlet weak var idpokemon: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var buttonStepper: UIStepper!
    
   private var pokemonId = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttonStepper.value = 1
        buttonStepper.minimumValue = 1
        buttonStepper.maximumValue = 151
        
        pokemonId = Int(buttonStepper.value)
        idpokemon.text = "Pokemon ID: \(pokemonId)"
        
        makeRequest()
    }
    
    @IBAction func stepperChanged(_ sender: UIStepper) {
        pokemonId = Int(sender.value)
        idpokemon.text = "Pokemon ID: \(pokemonId)"
        
        makeRequest()
    }
    
    
    private func makeRequest(){
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon/\(pokemonId)/") else{
            print(">>> URL passada como parametro é invalido")
            return
        }
        
        print(">>> Sucesso, URL passada é valida")
        let urlRequest = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: urlRequest) {data, _, error in
            if error != nil {
                print(">>> Requisição Realizada, mas a resposta foi um Error")
                return
            }
            
            guard let data = data else {
                print(">>>Error,data retornando vazio")
                return
            }
            
            if let response = try? JSONDecoder().decode(Response.self, from: data){
                DispatchQueue.main.async {
                    self.name.text = response.name.uppercased()
                }
                self.dowloadImage(url: response.sprites.other.official.urlImage)
            } else {
                print(">>> Error, a decodificação falhou verifique sua struct")
            }
        }.resume()
        
    }
    
    private func dowloadImage(url: String){
        guard let url = URL(string: url) else{
            print(">>> URL passada como parametro é invalido")
            return
        }
        
        print(">>> Sucesso, URL passada é valida")
        let urlRequest = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: urlRequest) {data, _, error in
            if error != nil {
                print(">>> Requisição Realizada, mas a resposta foi um Error")
                return
            }
            
            guard let data = data else {
                print(">>>Error,data retornando vazio")
                return
            }
            
            let uiImage = UIImage(data: data)
            DispatchQueue.main.async {
                self.image.image = uiImage
            }
        }.resume()
        
    }
}
