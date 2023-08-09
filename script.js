// Função para conectar com a MetaMask e redirecionar para a tela2.html após a conexão bem-sucedida
async function connectAndRedirect() {
  if (typeof window.ethereum === 'undefined') {
    alert('A carteira MetaMask não está instalada');
    return;
  }

  try {
    await window.ethereum.enable();
    alert('Conectado com sucesso à carteira MetaMask');
    window.location.href = 'tela2.html'; // Redirecionar para a tela2.html
  } catch (error) {
    console.error(error);
    alert('Falha ao conectar à carteira MetaMask');
  }
}

// Adicionar evento de clique ao botão de conexão
const connectButton = document.getElementById('connectButton');
connectButton.addEventListener('click', connectAndRedirect);

// Função para redirecionar para a tela de inserir número do contrato
function redirectToContractScreen() {
  window.location.href = "tela2.html";
}

// Função para redirecionar para a tela de informações do contrato
function redirectToContractInfoScreen() {
  window.location.href = "tela3.html";
}

// Event listener para o botão de enviar número do contrato
const submitContractButton = document.getElementById("submitContractButton");
submitContractButton.addEventListener("click", redirectToContractInfoScreen);
