import 'package:flutter/material.dart';

class AdminConfigScreen extends StatefulWidget {
  const AdminConfigScreen({super.key});

  @override
  State<AdminConfigScreen> createState() => _AdminConfigScreenState();
}

class _AdminConfigScreenState extends State<AdminConfigScreen> {
  
  final Color corTitulo = const Color(0xFF4D3820);
  final Color corTextoSecundario = const Color(0xFF6B4F28);
  final Color corFundoCard = const Color(0xFFFFFAF3);
  final Color corBorda = const Color(0xFFD6C9B8);

 
  bool _alertaVisivel = false;
  String _alertaMensagem = '';
  String _alertaTipo = 'success';

  
  String _tema = 'padrao';
  
  bool _notificarPedidos = true;
  bool _notificarErros = false;
  bool _somPedido = true;

  
  final TextEditingController _nomeCtrl = TextEditingController(text: 'Rancho Paracatu');
  final TextEditingController _adminCtrl = TextEditingController(text: 'Eduardo');
  final TextEditingController _mesasCtrl = TextEditingController(text: '15');
  final TextEditingController _preparoCtrl = TextEditingController(text: '40');
  final TextEditingController _rodapeCtrl = TextEditingController(text: 'O verdadeiro sabor da fazenda.');

  
  void _mostrarAlerta(String mensagem, String tipo) {
    setState(() {
      _alertaMensagem = mensagem;
      _alertaTipo = tipo;
      _alertaVisivel = true;
    });
    
    
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) setState(() => _alertaVisivel = false);
    });
  }

  void _salvar() {
    FocusScope.of(context).unfocus(); // Esconde o teclado
    _mostrarAlerta('Configurações salvas com sucesso!', 'success');
  }

  void _resetar() {
    FocusScope.of(context).unfocus();
    setState(() {
      _tema = 'padrao';
      _notificarPedidos = true;
      _notificarErros = false;
      _somPedido = true;
      _nomeCtrl.text = 'Rancho Paracatu';
      _adminCtrl.text = '';
      _mesasCtrl.text = '';
      _preparoCtrl.text = '';
      _rodapeCtrl.text = '';
    });
    _mostrarAlerta('Configurações resetadas para o padrão.', 'error'); // Usando vermelho para simular o reset
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 800), // max-w-4xl
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              if (_alertaVisivel)
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 24),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: _alertaTipo == 'success' ? Colors.green[600] : Colors.red[600],
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
                  ),
                  child: Text(
                    _alertaMensagem,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),

              
              Text('Configurações do Sistema', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: corTitulo)),
              const SizedBox(height: 32),

              
              _buildCard(
                titulo: 'Tema do Painel',
                subtitulo: 'Personalização visual',
                conteudo: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: corBorda),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: _tema,
                      items: const [
                        DropdownMenuItem(value: 'padrao', child: Text('Padrão')),
                        DropdownMenuItem(value: 'claro', child: Text('Claro')),
                        DropdownMenuItem(value: 'escuro', child: Text('Escuro')),
                        DropdownMenuItem(value: 'auto', child: Text('Automático')),
                      ],
                      onChanged: (val) => setState(() => _tema = val!),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              
              _buildCard(
                titulo: 'Notificações',
                subtitulo: 'Alertas importantes',
                conteudo: Column(
                  children: [
                    _buildSwitch('Notificar novos pedidos', _notificarPedidos, (val) => setState(() => _notificarPedidos = val)),
                    const SizedBox(height: 16),
                    _buildSwitch('Notificar erros do sistema', _notificarErros, (val) => setState(() => _notificarErros = val)),
                    const SizedBox(height: 16),
                    _buildSwitch('Som ao receber pedido', _somPedido, (val) => setState(() => _somPedido = val)),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              
              _buildCard(
                titulo: 'Informações do Restaurante',
                subtitulo: 'Dados institucionais',
                conteudo: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Nome', style: TextStyle(color: corTextoSecundario, fontSize: 14)),
                    const SizedBox(height: 4),
                    TextField(controller: _nomeCtrl, decoration: _inputDeco('Nome do restaurante')),
                    const SizedBox(height: 16),

                    Text('Administrador principal', style: TextStyle(color: corTextoSecundario, fontSize: 14)),
                    const SizedBox(height: 4),
                    TextField(controller: _adminCtrl, decoration: _inputDeco('Administrador')),
                    const SizedBox(height: 16),

                    
                    Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: [
                        SizedBox(
                          width: 200, // Largura fixa para quebrar a linha se não couber
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Total de mesas', style: TextStyle(color: corTextoSecundario, fontSize: 14)),
                              const SizedBox(height: 4),
                              TextField(controller: _mesasCtrl, keyboardType: TextInputType.number, decoration: _inputDeco('Ex: 15')),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 200,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Preparo médio (min)', style: TextStyle(color: corTextoSecundario, fontSize: 14)),
                              const SizedBox(height: 4),
                              TextField(controller: _preparoCtrl, keyboardType: TextInputType.number, decoration: _inputDeco('Ex: 40')),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    Text('Mensagem de rodapé', style: TextStyle(color: corTextoSecundario, fontSize: 14)),
                    const SizedBox(height: 4),
                    TextField(controller: _rodapeCtrl, maxLines: 3, decoration: _inputDeco('Digite a mensagem')),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  ElevatedButton.icon(
                    onPressed: _salvar,
                    icon: const Icon(Icons.save),
                    label: const Text('Salvar Alterações'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: corTitulo,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: _resetar,
                    icon: const Icon(Icons.delete_outline),
                    label: const Text('Resetar para Padrão'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[600],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

 

  
  Widget _buildCard({required String titulo, required String subtitulo, required Widget conteudo}) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: corFundoCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: corBorda),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(titulo, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: corTitulo)),
              ),
              const SizedBox(width: 16),
              Text(subtitulo, style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic, color: corTextoSecundario)),
            ],
          ),
          const SizedBox(height: 24),
          conteudo,
        ],
      ),
    );
  }

  
  Widget _buildSwitch(String label, bool valor, ValueChanged<bool> onChange) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded( 
          child: Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: corTitulo)),
        ),
        const SizedBox(width: 8),
        Switch(
          value: valor,
          onChanged: onChange,
          activeColor: Colors.white,
          activeTrackColor: Colors.green[600],
          inactiveThumbColor: Colors.white,
          inactiveTrackColor: Colors.grey[400],
        ),
      ],
    );
  }

  
  InputDecoration _inputDeco(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.black38),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: corBorda), borderRadius: BorderRadius.circular(8)),
      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: corTitulo, width: 2), borderRadius: BorderRadius.circular(8)),
    );
  }
}