# Documentação: Desenvolvimento de Aplicação Web para Saúde da Mulher e Gravidez

## Visão Geral do Projeto
Desenvolva uma aplicação web completa focada em saúde da mulher e gravidez, direcionada a dois públicos principais:
1. Mulheres que desejam saber se estão grávidas ou que estão planejando uma gravidez
2. Mulheres que já estão grávidas e buscam acompanhar sua gestação

## Funcionalidades Principais

### 1. Calculadora de Período Fértil
- Interface intuitiva para inserção da data do último ciclo menstrual
- Campo para informar a duração média do ciclo (com valor padrão de 28 dias)
- Exibição visual do calendário com marcação dos dias férteis
- Opção para salvar histórico de ciclos (com conta de usuário)
- Notificações opcionais de aproximação do período fértil

### 2. Calculadora de Semanas de Gestação
- Cálculo baseado na data da última menstruação (DUM)
- Exibição da idade gestacional em semanas e dias
- Visualização do trimestre atual da gravidez
- Estimativa da data provável do parto (DPP)
- Informações sobre o desenvolvimento do bebê em cada semana

### 3. Calculadora de IMC (Índice de Massa Corporal)
- Campos para inserção de peso e altura
- Cálculo automático do IMC atual
- Interpretação do resultado com recomendações específicas para gestantes
- Gráfico de acompanhamento de peso durante a gestação
- Recomendações de ganho de peso adequado por trimestre

### 4. Biblioteca de Artigos Informativos
Desenvolva uma seção de conteúdo com artigos sobre:
- **Saúde da Mulher**: exames preventivos, nutrição, exercícios recomendados
- **Métodos Anticoncepcionais**: tipos, eficácia, vantagens e desvantagens
- **Cuidados Durante a Gravidez**: alimentação, atividades físicas, exames recomendados
- **Sinais de Gravidez**: sintomas comuns, quando fazer o teste
- **Dicas para mães de primeira viagem**: dicas para que será mãe pela primeira vez
- **Pré-natal**: importância, exames, consultas recomendadas
- **Bem-estar Emocional**: lidando com ansiedade, mudanças emocionais na gravidez
- **Amamentação**: preparação, técnicas, desafios comuns

### 5. Sistema de Cadastro e Histórico de Resultados
- Criação de conta nome, com e-mail e senha (ou integração com Google/Facebook)
- Painel da usuária com histórico completo de todos os cálculos realizados
- Visualização de gráficos de linha para acompanhamento dos resultados ao longo do tempo:
  - Gráfico de ciclos menstruais e períodos férteis
  - Gráfico de evolução do IMC durante a gravidez
  - Evolução da gravidez em semanas com marcos importantes
- Exportação de dados em formato PDF para compartilhar com profissionais de saúde
- Configurações de privacidade e controle sobre os dados armazenados
- **Aviso importante**: Implementar notificações claras indicando que sem cadastro os resultados serão perdidos ao sair do site

## Requisitos Técnicos
- Utilizar *Ruby on Rails* 8 para desenvolvimento completo da aplicação
- *Frontend* integrado usando *Tailwind CSS* para estilização e componentes
- Implementar componentes UI avançados com Tailwind CSS
- Arquitetura MVC conforme padrão Rails para organização do código
- Implementar design responsivo (mobile-first)
- Utilizar Active Record para modelagem de dados e interação com banco de dados
- PostgreSQL para banco de dados principal
- SQLite3 com Solid Cache para cache
- Implementar Devise para sistema de autenticação de usuárias
- Utilizar Hotwire (Turbo e Stimulus) para interatividade no frontend
- Implementar 'chartkick' + 'highcharts' para gráficos de linha, e fráficos de tendência do histórico de peso e IMC
- Configurar Action Mailer para envio de e-mails transacionais
- Conformidade com LGPD para dados pessoais e de saúde
- Implementação de cookies de sessão com avisos apropriados
- Sistema de backup automático de dados de usuárias

## Considerações de UX/UI
- Paleta de cores suave e acolhedora
- Navegação intuitiva e simplificada
- Carregamento rápido e experiência fluida
- Linguagem acessível e inclusiva
- Ilustrações e gráficos informativos
- Disclaimers claros sobre a natureza informativa (não substituindo aconselhamento médico)
- Modal de aviso sobre perda de dados para usuárias não cadastradas
- Tutorial interativo para novos usuários explicando os benefícios do cadastro

## Recursos Adicionais Desejáveis
- Função de perguntas frequentes (FAQ)
- Glossário de termos médicos relacionados à gravidez
- Comunidade/fórum para troca de experiências
- Lista de verificação para preparação para o parto
- Opção de compartilhamento de progresso com parceiro/família
- Lembretes por e-mail ou notificações push (para usuárias cadastradas)

## Observações Importantes
- Todos os cálculos e informações devem incluir disclaimers médicos
- O conteúdo deve ser baseado em fontes médicas confiáveis
- Considerar aspectos culturais e socioeconômicos diversos
- Garantir acessibilidade para usuárias com deficiências
- Implementar sistema de feedback para melhoria contínua da plataforma
- Avisos claros e visíveis sobre a necessidade de cadastro para salvar dados
- Política de privacidade e termos de uso detalhados e de fácil compreensão
