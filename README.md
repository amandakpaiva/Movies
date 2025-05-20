# Movies


## Descrição

O **Movies App** é um aplicativo iOS que utiliza a arquitetura **MVVM** para gerenciar dados, navegação e interações de usuário. O app exibe uma lista de filmes obtidos a partir de uma API pública e permite ao usuário adicionar filmes favoritos, que são persistidos localmente utilizando **UserDefaults**. Além disso, o aplicativo fornece uma tela de detalhes para cada filme, com informações adicionais.

## Funcionalidades

- **Exibição de Filmes:** A lista de filmes é buscada a partir de uma API externa.
- **Pesquisa de Filmes:** Funcionalidade de busca que permite ao usuário encontrar filmes específicos.
- **Favoritos:** O usuário pode adicionar filmes à lista de favoritos. Esses filmes são armazenados localmente usando **UserDefaults**.
- **Tela de Detalhes:** Ao clicar em um filme, o usuário pode ver mais detalhes sobre o filme selecionado.
- **Navegação com Coordinator:** A navegação entre telas é gerenciada utilizando o padrão **Coordinator**, permitindo um controle centralizado sobre as transições de telas.
- **Testes Unitários:** O projeto possuí ampla cobertura de testes usando **XCTest** para garantir o funcionamento correto das funcionalidades principais.
- **Idiomas:** O projeto possui suporte aos idiomas inglês e português usando .localizable strings.
- **Integração SwiftUI:** Utiliza **UIHostingController** para integrar componentes SwiftUI dentro da aplicação UIKit.

## Tecnologias Utilizadas

- **Swift** – Linguagem de programação principal.
- **UIKit** – Framework utilizado para a criação das interfaces de usuário.
- **SwiftUI** – Framework moderno da Apple utilizado em conjunto com UIKit através de UIHostingController.
- **UserDefaults** – Utilizado para persistir dados localmente (favoritos).
- **XCTest** – Framework de testes unitários para garantir a qualidade do código.

## Estrutura do Projeto

1. **Model:** Contém a estrutura dos dados utilizados pelo aplicativo (por exemplo, o modelo `Movie`).
2. **View:** Contém as interfaces de usuário responsáveis pela exibição de dados, incluindo componentes SwiftUI integrados via UIHostingController.
3. **ViewModel:** Contém a lógica de negócios e comunicação com a camada de modelo e View.
4. **Coordinator:** Gerencia a navegação entre as telas de forma centralizada, garantindo que as transições de tela sejam feitas de maneira desacoplada.
5. **API Service:** Responsável por buscar os dados da API externa e realizar pesquisas de filmes.
6. **Persistence:** Utiliza **UserDefaults** para persistir filmes favoritos.

## Como Rodar o Projeto

1. Clone o repositório:
    ```bash
    git clone https://github.com/amandakpaiva/Movies
    ```

2. Abra o projeto no **Xcode** na branch main.

3. Execute o projeto em um simulador.

4. Caso queira testar a persistência de favoritos, adicione filmes à lista de favoritos e feche o app. Ao reabrir, a lista será mantida.

## Contato

Se houverem dúvidas ou sugestões, fique à vontade para me contatar:

- **E-mail:** [amandakpaiva@gmail.com](mailto:amandakpaiva@gmail.com)
- **LinkedIn:** [www.linkedin.com/in/amandakpaiva](https://www.linkedin.com/in/amandakpaiva)
