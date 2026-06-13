import 'package:flutter/material.dart';
import 'core/theme/app_colors.dart';
import '../widgets/custom_drawer.dart'; 

class SobreScreen extends StatelessWidget {
  const SobreScreen({super.key});

  final Color corTexto = const Color(0xFF4D5A2A);
  final Color corTitulo = const Color(0xFF2E2414);
  final Color corBorda = const Color(0x4D6B4F28); 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fundo,
      
      appBar: AppBar(
        title: const Text('Sobre o Rancho'),
      ),

      drawer: const CustomDrawer(), 

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0), 
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            _buildParagrafo(
                'O Rancho Paracatu nasceu com a proposta de trazer conforto, tradição e o verdadeiro sabor da culinária brasileira. Cada prato é preparado com carinho, ingredientes selecionados e aquele toque caseiro que faz toda a diferença.'),
            const SizedBox(height: 16),
            _buildParagrafo(
                'Aqui valorizamos a boa comida, o bom atendimento e a experiência completa. Nosso espaço foi pensado para que famílias, amigos e visitantes se sintam em casa — como todo bom rancho deve ser.'),
            const SizedBox(height: 16),
            _buildParagrafo(
                'Tudo começou com o sonho de oferecer refeições saborosas em um ambiente acolhedor. Ao longo dos anos, o Rancho Paracatu cresceu, conquistando clientes e mantendo sua essência simples e gostosa.'),
            const SizedBox(height: 16),
            _buildParagrafo(
                'Trabalhamos com receitas tradicionais e ingredientes frescos. Cada prato é preparado com cuidado para entregar um sabor marcante e autêntico.'),
            const SizedBox(height: 16),
            _buildParagrafo(
                'Uma equipe apaixonada pelo que faz, sempre pronta para servir bem e garantir que cada visita ao rancho seja inesquecível.'),
            const SizedBox(height: 16),
            _buildParagrafo(
                'Comida simples, ambiente agradável e atendimento de qualidade. É isso que acreditamos e praticamos todos os dias.'),

            const SizedBox(height: 40),

            Text('Nosso Espaço', style: _estiloTitulo()),
            const SizedBox(height: 16),
            _buildParagrafo(
                'Cada canto do Rancho Paracatu foi pensado para trazer conforto, rusticidade e uma experiência acolhedora. Aqui estão alguns registros do nosso ambiente.'),
            
            const SizedBox(height: 40),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: _estiloCard(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Nossa Localização', style: _estiloTitulo()),
                  const SizedBox(height: 16),
                  _buildParagrafo(
                      'Estamos em um espaço acolhedor na região de São Joaquim — ideal para quem busca boa comida, ambiente confortável e aquele clima rústico típico do Rancho Paracatu.'),
                  const SizedBox(height: 20),
                  
                  Container(
                    height: 250,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: corBorda),
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.map, size: 50, color: Colors.grey),
                        SizedBox(height: 10),
                        Text('Mapa do Google Maps entrará aqui'),
                      ],
                    ),
                  )
                ],
              ),
            ),

            const SizedBox(height: 40),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: _estiloCard(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Informações do Local', style: _estiloTitulo()),
                  const SizedBox(height: 24),
                  
                  Wrap(
                    spacing: 20, 
                    runSpacing: 24, 
                    children: [
                      _buildInfoBlock('Acessibilidade', ['Entrada com acessibilidade']),
                      _buildInfoBlock('Opções de Serviço', ['Mesas externas', 'Refeição no local']),
                      _buildInfoBlock('Destaques', ['Música ao vivo', 'Shows ao vivo', 'Ótima seleção de cervejas', 'Ótimos coquetéis']),
                      _buildInfoBlock('Ambiente', ['Aconchegante', 'Casual', 'Tranquilo', 'Tendência']),
                      _buildInfoBlock('Menu & Bebidas', ['Bebidas alcoólicas', 'Destilados', 'Coquetéis', 'Vinho', 'Comida no bar']),
                      _buildInfoBlock('Planejamento', ['Aceita reservas']),
                      _buildInfoBlock('Público', ['Grupos', 'Turistas', 'Bom para ir com crianças']),
                      _buildInfoBlock('Pagamentos', ['Cartão de crédito', 'Cartão de débito', 'Pagamentos por NFC']),
                      _buildInfoBlock('Estacionamento', ['Muitas vagas disponíveis', 'Estacionamento descoberto gratuito', 'Estacionamento gratuito na rua']),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 40),

            // NOVO BLOCO: RF004 - Informações Institucionais
            Container(
              padding: const EdgeInsets.all(20),
              decoration: _estiloCard(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Projeto Acadêmico', style: _estiloTitulo()),
                  const SizedBox(height: 16),
                  _buildParagrafo('Este aplicativo foi desenvolvido como parte dos requisitos de avaliação da disciplina.'),
                  const SizedBox(height: 16),
                  _buildProjetoInfo('Disciplina', 'Prática Extensionista VIII'),
                  _buildProjetoInfo('Desenvolvedores', 'Eduardo Gondim Tomazini, Felipy Rodrigues Fuga'),
                  _buildProjetoInfo('Professor(a)', 'Dr. Rodrigo De Oliveira Plotze'),
                  _buildProjetoInfo('Versão', '1.0.0'),
                ],
              ),
            ),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, '/contato');
                },
                icon: const Icon(Icons.mail),
                label: const Text('Fale Conosco', style: TextStyle(fontSize: 18)),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
            
            const SizedBox(height: 40), 
          ],
        ),
      ),
    );
  }

  Widget _buildParagrafo(String texto) {
    return Text(
      texto,
      style: TextStyle(
        fontSize: 16,
        color: corTexto,
        height: 1.5,
      ),
    );
  }

  Widget _buildInfoBlock(String titulo, List<String> itens) {
    return SizedBox(
      width: 160, 
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titulo,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: corTitulo),
          ),
          const SizedBox(height: 8),
          ...itens.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text('• $item', style: TextStyle(fontSize: 15, color: corTexto)),
              )),
        ],
      ),
    );
  }

  Widget _buildProjetoInfo(String label, String valor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: RichText(
        text: TextSpan(
          style: TextStyle(fontSize: 16, color: corTexto, height: 1.5),
          children: [
            TextSpan(text: '$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: valor),
          ],
        ),
      ),
    );
  }

  TextStyle _estiloTitulo() {
    return TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      color: corTitulo,
    );
  }

  BoxDecoration _estiloCard() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: corBorda),
      boxShadow: const [
        BoxShadow(
          color: Color.fromARGB(13, 0, 0, 0), // Aviso withOpacity corrigido
          blurRadius: 10,
          offset: Offset(0, 4),
        ),
      ],
    );
  }
}