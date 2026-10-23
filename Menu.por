programa {
	inclua biblioteca Graficos --> g
	inclua biblioteca Mouse --> m
	inclua biblioteca Util --> u
	inclua biblioteca Teclado --> t
	inclua biblioteca Matematica --> mat
	inclua biblioteca Tipos --> tp
	inclua biblioteca Sons --> sm
	inclua biblioteca Texto --> txt
	inclua biblioteca Arquivos --> arq

		// -- Pong Game -
	inteiro tela_w = 0, tela_h = 0
	const inteiro LINHAS_PONG = 31
	const inteiro COLUNAS_PONG = 51
	const inteiro X = 0
	const inteiro Y = 1
	const inteiro LARGURIA = 2
	const inteiro ARTURIA = 3
	const inteiro IMAGEM = 4
	const inteiro PONTUACAO_PONG = 5
	const inteiro V_HORIZONTAL = 5
	const inteiro V_VERTICAL = 6
	const inteiro ACELERACAO = 7
	inteiro cor_principal=0, cor_secundaria=0, cor_fundo=0
	inteiro branco=0, verde=0
	inteiro matriz_fundo[LINHAS_PONG][COLUNAS_PONG]
	inteiro tamanho_tile=32
	inteiro campo[5]
	real tamanho_fonte
	inteiro pontuacao_y, pontuacao1_x, pontuacao2_x, pontuacao_img = -1, imagem_pausa=-1, portugol=-1
	inteiro tempo_anterior_demo
	logico DEMO_mode = falso
	inteiro player1[6], player2[6], bolinha[8], passo=1, max_vel=7
	inteiro velocidade_player = 8 
	inteiro colision_music = -1, colision_play
	logico fonte_pong_carregada = falso
	logico pausado = falso
	inteiro forca1 = 0
	inteiro forca2 = 0
	logico carregando1 = falso
	logico carregando2 = falso
	const inteiro FORCA_MAX = 10
	// Rebatida Aleatória só pode ser comprada até este nível (1 = compra única)
	const inteiro NIVEL_MAX_REBATIDA = 1
	// Altura dos rebatedores em "tiles" (a largura sai proporcional ao sprite).
	// A hitbox usa exatamente esse tamanho. Aumente/diminua este valor para mudar o personagem.
	const inteiro ALTURA_JOGADOR_TILES = 6
	inteiro img_batedor1 = -1
	inteiro img_batedor2 = -1
	inteiro bola_beisebol = -1
	inteiro imagem_fundo_pong = -1
	inteiro img_batedor1_meio = -1
	inteiro img_batedor1_fim = -1
	inteiro img_batedor2_meio = -1
	inteiro img_batedor2_fim = -1

	inteiro frame_animacao2 = 0
	inteiro tempo_animacao2 = 0
	logico animando2 = falso	

	inteiro frame_animacao1 = 0
	inteiro tempo_animacao1 = 0
	logico animando1 = falso

	// Estados do menu Pong
	const inteiro MENU_PONG = 0
	const inteiro JOGANDO_PONG = 1
	const inteiro UPGRADES_PONG = 2
	const inteiro SAIR_PONG = 3

	// Controle do menu
	inteiro estado_pong = MENU_PONG
	inteiro opcao_menu_pong = 0
	inteiro imagem_fundo_menu_pong = -1

	inteiro som_lobby = -1
	inteiro som_jogo = -1
	inteiro canal_lobby = -1
	inteiro canal_jogo = -1

	inteiro sel_upg_p1 = 0
	inteiro sel_upg_p2 = 0

	// Níveis atuais das melhorias (0 = não comprado, 1 = comprado para ativas)
	inteiro lvl_upg_p1[4] = {0, 0, 0, 0}
	inteiro lvl_upg_p2[4] = {0, 0, 0, 0}

	// Custos de cada melhoria
	inteiro custo_upg[4] = {3, 5, 8, 5}

	// Contadores de rebatidas para a mecânica de moedas
	inteiro batidas_p1 = 0
	inteiro batidas_p2 = 0

	// Saldo de moedas/Strikecoins de cada jogador
	inteiro strikecoins_p1 = 0
	inteiro strikecoins_p2 = 0

	// Nomes das 4 melhorias
	cadeia nomes_upgrades[4] = {
		"Rebatida Aleatória",
		"Aumento de Velocidade",
		"Confusão",
		"Congelamento"
	}

	inteiro botao_habilidade1 = -1
	inteiro botao_habilidade2 = -1

	// Área de clique (retângulo) de cada botão
	inteiro botao1_x, botao1_y, botao1_larg, botao1_alt
	inteiro botao2_x, botao2_y, botao2_larg, botao2_alt

	// ============ NOVAS VARIÁVEIS PARA HABILIDADES ATIVAS ============
	// Usos restantes por habilidade (índices 1,2,3 são ativas)
	inteiro usos_p1[4] = {0,0,0,0}
	inteiro usos_p2[4] = {0,0,0,0}
	// Habilidade ativa atual (índice da última comprada, -1 se nenhuma)
	inteiro habilidade_ativa_p1 = -1
	inteiro habilidade_ativa_p2 = -1

	// Efeitos ativos
	logico efeito_velocidade_p1 = falso
	logico efeito_confusao_p1 = falso
	logico efeito_congelamento_p1 = falso
	logico efeito_velocidade_p2 = falso
	logico efeito_confusao_p2 = falso
	logico efeito_congelamento_p2 = falso

	// Temporizadores dos efeitos (em ms)
	inteiro tempo_velocidade_p1 = 0
	inteiro tempo_confusao_p1 = 0
	inteiro tempo_congelamento_p1 = 0
	inteiro tempo_velocidade_p2 = 0
	inteiro tempo_confusao_p2 = 0
	inteiro tempo_congelamento_p2 = 0

	const inteiro DURACAO_EFEITO = 5000  // 5 segundos
	const real FATOR_VELOCIDADE = 1.5
	const real FATOR_CONGELAMENTO = 0.5

	// Velocidades base e atuais dos jogadores
	inteiro velocidade_base_p1 = 8
	inteiro velocidade_base_p2 = 8
	inteiro velocidade_atual_p1 = 8
	inteiro velocidade_atual_p2 = 8

	// Confusão (inverte teclas)
	logico confusao_p1 = falso
	logico confusao_p2 = falso

	// Congelamento global (afeta a velocidade da bola)
	real fator_congelamento_global = 1.0
	inteiro tempo_congelamento_global = 0

	inteiro ultimo_uso_habilidade = 0
	
	funcao inicio()
	{	
		inteiro estado_pong = MENU_PONG
		inteiro opcao_menu_pong = 0   // 0 = Jogar, 1 = Upgrades
		inteiro imagem_fundo_menu_pong = -1

		inteiro imagem_fundo
		inteiro img_corrida, img_pong, img_serpente, img_sair

		// Controle da exibição da caixa de Informações
		logico mostrar_info = falso

		// Inicializa a janela gráfica principal
		g.iniciar_modo_grafico(verdadeiro)
		g.definir_dimensoes_janela(785, 900)
		g.definir_titulo_janela("Menu de Opções")

		// Carrega as imagens do menu e dos botões
		imagem_fundo = g.carregar_imagem("Menu/Fundo.png")
		img_corrida = g.carregar_imagem("Menu/Corrida.png")
		img_pong = g.carregar_imagem("Menu/Pong.png")
		img_sair = g.carregar_imagem("Menu/Sair.png")

		g.redimensionar_imagem(img_corrida, 535, 120, falso)
		g.redimensionar_imagem(img_pong, 535, 120, falso)
		g.redimensionar_imagem(img_sair, 535, 120, falso)

		logico executando = verdadeiro

		enquanto (executando)
		{
			g.desenhar_imagem(0, 0, imagem_fundo)

			// Desenho dos botões do menu
			g.desenhar_imagem(89, 130, img_corrida)
			g.desenhar_imagem(89, 310, img_pong)
			g.desenhar_imagem(89, 490, img_sair)

			// --- BOTÃO DE INFORMAÇÕES (Canto Inferior Direito) ---
			g.definir_opacidade(80)
			g.definir_cor(g.COR_PRETO)
			g.desenhar_retangulo(643, 766, 110, 50, verdadeiro, verdadeiro)

			g.definir_opacidade(200)
			g.definir_cor(g.COR_PRETO)
			g.desenhar_retangulo(640, 764, 110, 50, verdadeiro, verdadeiro)

			g.definir_opacidade(255)
			g.definir_cor(g.COR_AMARELO)
			g.desenhar_retangulo(640, 764, 110, 50, verdadeiro, falso)

			g.definir_cor(g.COR_AMARELO)
			g.desenhar_elipse(655, 776, 26, 26, verdadeiro)
			g.definir_cor(g.COR_PRETO)
			g.definir_tamanho_texto(18.0)
			g.desenhar_texto(666, 780, "i")

			g.definir_cor(g.COR_BRANCO)
			g.definir_tamanho_texto(16.0)
			g.desenhar_texto(690, 780, "INFO")

			se (m.botao_pressionado(m.BOTAO_ESQUERDO))
			{
				inteiro mouse_x = m.posicao_x()
				inteiro mouse_y = m.posicao_y()

				se (mostrar_info)
				{
					mostrar_info = falso
					u.aguarde(200)
				}
				senao
				{
					se (mouse_x >= 89 e mouse_x <= 624 e mouse_y >= 240 e mouse_y <= 440)
					{
						executar_jogo_corrida()
						g.definir_dimensoes_janela(785, 1024)
						g.definir_titulo_janela("Menu de Opções")
					}
					senao se (mouse_x >= 89 e mouse_x <= 624 e mouse_y >= 460 e mouse_y <= 620)
					{
						executar_jogo_pong()
					}
					senao se (mouse_x >= 89 e mouse_x <= 624 e mouse_y >= 630 e mouse_y <= 800)
					{
						executando = falso
					}
					senao se (mouse_x >= 640 e mouse_x <= 750 e mouse_y >= 760 e mouse_y <= 820)
					{
						mostrar_info = verdadeiro
						u.aguarde(200)
					}
				}
			}

			se (mostrar_info)
			{
				g.definir_opacidade(240)
g.definir_cor(g.COR_PRETO)
g.desenhar_retangulo(30, 25, 725, 850, verdadeiro, verdadeiro)

g.definir_opacidade(255)
g.definir_cor(g.COR_AMARELO)
g.desenhar_retangulo(30, 25, 725, 850, verdadeiro, falso)

g.definir_tamanho_texto(28.0)
g.definir_cor(g.COR_AMARELO)
g.desenhar_texto(210, 50, "CENTRAL DE JOGOS — v1.0")

g.definir_tamanho_texto(15.0)
g.definir_cor(g.COR_BRANCO)
g.desenhar_texto(70, 95, "Desenvolvido por: Jackson C. Giordani e Lucas E. V. Bôas")
g.desenhar_texto(70, 115, "Curso Técnico em Desenvolvimento de Sistemas — 2025")

g.definir_tamanho_texto(19.0)
g.definir_cor(g.COR_AMARELO)
g.desenhar_texto(70, 155, "CORRIDA:")
g.definir_cor(g.COR_BRANCO)
g.definir_tamanho_texto(15.0)
g.desenhar_texto(70, 185, "Jogo para dois jogadores em que o objetivo é percorrer a pista")
g.desenhar_texto(70, 207, "e alcançar a maior distância possível. P1 utiliza WASD e P2,")
g.desenhar_texto(70, 229, "as setas do teclado. Desvie dos veículos, colete estrelas para")
g.desenhar_texto(70, 251, "comprar skins e melhorias e pegue galões para abastecer.")
g.desenhar_texto(70, 273, "Gerencie a velocidade e o combustível para continuar na disputa.")

g.definir_tamanho_texto(19.0)
g.definir_cor(g.COR_AMARELO)
g.desenhar_texto(70, 315, "PONG:")
g.definir_cor(g.COR_BRANCO)
g.definir_tamanho_texto(15.0)
g.desenhar_texto(70, 345, "Uma versão de Beisebol Pong para dois jogadores, com habilidades")
g.desenhar_texto(70, 367, "e melhorias que tornam cada partida mais estratégica. P1 utiliza")
g.desenhar_texto(70, 389, "W/S para se movimentar e Espaço para controlar a força da rebatida.")
g.desenhar_texto(70, 411, "P2 utiliza as setas e Enter. Compre melhorias com Strikecoins,")
g.desenhar_texto(70, 433, "ative habilidades durante a partida e tente superar seu adversário.")

g.definir_tamanho_texto(19.0)
g.definir_cor(g.COR_AMARELO)
g.desenhar_texto(70, 475, "SISTEMA DE PROGRESSÃO:")
g.definir_cor(g.COR_BRANCO)
g.definir_tamanho_texto(15.0)
g.desenhar_texto(70, 505, "Na Corrida, utilize as estrelas coletadas para desbloquear skins")
g.desenhar_texto(70, 527, "e melhorias. No Pong, acumule Strikecoins durante as rebatidas")
g.desenhar_texto(70, 549, "para adquirir vantagens e habilidades especiais.")
g.desenhar_texto(70, 571, "Cada melhoria pode alterar sua estratégia e o resultado da partida.")

g.definir_tamanho_texto(19.0)
g.definir_cor(g.COR_AMARELO)
g.desenhar_texto(70, 613, "SAIR:")
g.definir_cor(g.COR_BRANCO)
g.definir_tamanho_texto(15.0)
g.desenhar_texto(70, 643, "Encerra o Menu de Jogos e fecha o programa.")

g.definir_tamanho_texto(15.0)
g.definir_cor(g.COR_VERDE)
g.desenhar_texto(70, 685, "DICA: Pressione ESC para sair de qualquer jogo.")

g.definir_tamanho_texto(14.0)
g.definir_cor(g.COR_AZUL)
g.desenhar_texto(210, 835, "[ Clique fora desta caixa para fechar ]")
			}

			g.renderizar()
		}

		g.liberar_imagem(imagem_fundo)
		g.liberar_imagem(img_corrida)
		g.liberar_imagem(img_pong)
		
		g.liberar_imagem(img_sair)
		
		g.encerrar_modo_grafico()
	}
		

	

	// CONFIGURAÇÃO DO JOGO
	const inteiro LARGURA = 800
	const inteiro ALTURA = 600
	const inteiro LARGURA_PISTA = 400
	const inteiro LARGURA_ACOSTAMENTO = 20
	
	// PROPRIEDADES DOS OBJETOS
	const inteiro _X = 0
	const inteiro _Y = 1
	const inteiro _MODELO = 2
	
	// PROPRIEDADES DOS MODELOS DE VEÍCULOS
	const inteiro _SX = 0
	const inteiro _SY = 1
	const inteiro _LARGURA = 2
	const inteiro _ALTURA = 3

	// PROPRIEDADES DOS GALÕES DE COMBUSTÍVEL
	const real MAXIMO_COMBUSTIVEL = 20000.0
	const real COMBUSTIVEL_GALAO = 5000.0
	const inteiro LARGURA_MEDIDOR = 156
	const inteiro ALTURA_MEDIDOR = 8
	const inteiro _OBJ_GALAO_SX = 402
	const inteiro _OBJ_GALAO_SY = 0
	const inteiro _OBJ_GALAO_LARGURA = 21
	const inteiro _OBJ_GALAO_ALTURA = 31

	// ESTADOS DO JOGO
	const inteiro ESTADO_MENU = 0
	const inteiro ESTADO_JOGANDO = 1
	const inteiro ESTADO_GAME_OVER = 2
	const inteiro ESTADO_SKINS = 3
	const inteiro ESTADO_MELHORIAS = 4

	// DISTÂNCIAS DE SPAWN
	const inteiro MAIOR_DISTANCIA_VEICULOS = 500
	const inteiro MENOR_DISTANCIA_VEICULOS = 150

	// CARROS E STATUS DOS JOGADORES
	inteiro jogador1[3] = {0, 0, 0}
	inteiro jogador2[3] = {0, 0, 1}
	
	logico jogador1_vivo = verdadeiro
	logico jogador2_vivo = falso

	// ATRIBUTOS E UPGRADES DOS JOGADORES
	inteiro nivel_vida_p1 = 1
	inteiro nivel_vida_p2 = 1
	inteiro vidas_p1 = 1
	inteiro vidas_p2 = 1
	
	inteiro nivel_combustivel_p1 = 1
	inteiro nivel_combustivel_p2 = 1
	
	inteiro nivel_velocidade_p1 = 1
	inteiro nivel_velocidade_p2 = 1
	
	logico mult_estrelas_p1 = falso
	logico mult_estrelas_p2 = falso
	
	inteiro opcao_melhoria_p1 = 0
	inteiro opcao_melhoria_p2 = 0

	// COMBUSTÍVEL DOS JOGADORES
	real combustivel_p1 = 20000.0
	real combustivel_p2 = 20000.0
	logico alarme_p1_tocado = falso
	logico alarme_p2_tocado = falso

	// MATRIZ DE MODELOS DE VEÍCULOS
	inteiro MODELOS_VEICULOS[][] =
	{
		{   0,   0,  44,  96 }, {  43,   0,  44,  96 }, {  86,   0,  44,  96 }, { 129,   0,  44,  96 }, 
		{ 172,  0 ,  44,  96 }, {   0,  97,  44,  96 }, {  43,  97,  44,  96 }, {  86,  97,  44,  96 },
		{ 129,  97,  44,  96 }, { 172,  97,  44,  96 }, {   0, 195,  44,  96 }, {  43, 195,  44,  96 }, 
		{  86, 195,  44,  96 }, { 129, 195,  44,  96 }, { 172, 197,  44,  94 }, {   0, 293,  42,  99 },
		{  42, 293,  42,  99 }, {  85, 293,  42,  99 }, { 128, 293,  42,  99 }, { 172, 293,  42,  99 },
		{ 217,   0,  41,  87 }, { 217,  89,  41,  87 }, { 217, 179,  41,  87 }, { 217, 269,  41,  88 },
		{ 263,   0,  66, 374 }, { 331,   0,  67, 370 }
	}

	// SISTEMA DE SKINS E BANCO DE ESTRELAS
	inteiro banco_estrelas_p1 = 0
	inteiro banco_estrelas_p2 = 0
	logico skins_desbloqueadas_p1[24]
	logico skins_desbloqueadas_p2[24]
	inteiro visualizando_skin_p1 = 0
	inteiro visualizando_skin_p2 = 1
	const inteiro PRECO_SKIN = 2

	// INIMIGOS, ESTRELAS E GALÕES
	inteiro inimigos_p1[5][3]
	inteiro inimigos_p2[5][3]
	inteiro estrelas_p1[2][2]
	inteiro estrelas_p2[2][2]
	inteiro galoes_p1[2][2]
	inteiro galoes_p2[2][2]

	// IMAGENS (INICIALIZADAS COM 0)
	inteiro imagem_estrada = 0
	inteiro imagem_veiculos = 0
	inteiro imagem_estrela = 0
	inteiro imagem_objetos = 0
	inteiro imagem_logo = 0
	inteiro imagem_fundo_menu = 0

	// SONS (INICIALIZADOS COM 0)
	inteiro musica_jogo = 0
	inteiro musica_menu = 0
	inteiro som_alarme_combustivel = 0
	inteiro som_colisao = 0
	inteiro som_combustivel = 0
	inteiro som_freio = 0
	inteiro som_largada = 0
	inteiro som_ligar = 0
	inteiro som_reparo = 0
	inteiro som_trafego = 0

	// REGRAS E ESTATÍSTICAS
	real velocidade_p1 = 12.0
	real velocidade_p2 = 12.0
	real pontuacao_p1 = 0.0
	real pontuacao_p2 = 0.0
	inteiro estrelas_p1_qtd = 0
	inteiro estrelas_p2_qtd = 0
	inteiro estado_jogo = ESTADO_MENU
	real deslocamento_estrada = 0.0
	
	// VARIÁVEIS DE MENU E ÁUDIO
	inteiro opcao_menu = 0 
	inteiro cooldown_tecla = 0
	inteiro cooldown_freio = 0
	logico musica_menu_tocando = falso
	logico musica_jogo_tocando = falso

	// -------------------------------------------------------------
	// Função do Jogo de Pong 
	// -------------------------------------------------------------
	
	
		funcao executar_jogo_pong()
	{
		// Carrega as imagens se ainda não foram carregadas
		se (img_batedor1 == -1) img_batedor1 = g.carregar_imagem("pong/Rebatedores/Rebatedor_Azul.png")
		se (img_batedor1_meio == -1) img_batedor1_meio = g.carregar_imagem("pong/Rebatedores/Rebatedor_Azul_meiaRebatida.png")
		se (img_batedor1_fim == -1) img_batedor1_fim = g.carregar_imagem("pong/Rebatedores/Rebatedor_Azul_fimRebatida.png")
		
		se (img_batedor2 == -1) img_batedor2 = g.carregar_imagem("pong/Rebatedores/Rebatedor_Vermelho.png")
		se (img_batedor2_meio == -1) img_batedor2_meio = g.carregar_imagem("pong/Rebatedores/Rebatedor_Vermelho_meiaRebatida.png")
		se (img_batedor2_fim == -1) img_batedor2_fim = g.carregar_imagem("pong/Rebatedores/Rebatedor_Vermelho_fimRebatida.png")
		
		se (bola_beisebol == -1) bola_beisebol = g.carregar_imagem("pong/Fundos_e_Bola/bola_beisebol.png")
		
		se (imagem_fundo_menu_pong == -1)
			imagem_fundo_menu_pong = g.carregar_imagem("pong/Fundos_e_Bola/fundo_menu_pong.png")

		se (som_lobby == -1) som_lobby = sm.carregar_som("pong/Sons/MusicaLobby.mp3") 
		se (som_jogo == -1) som_jogo = sm.carregar_som("pong/Sons/MusicaJogo.mp3")
		
		inicializar()

		// Fundo do menu ocupando a tela toda (tela_w/tela_h só são conhecidos após inicializar())
		se (imagem_fundo_menu_pong != -1)
			imagem_fundo_menu_pong = ajustar_imagem(imagem_fundo_menu_pong, tela_w, tela_h)
		
		estado_pong = MENU_PONG
		opcao_menu_pong = 0

		se (canal_lobby == -1)
			canal_lobby = sm.reproduzir_som(som_lobby, verdadeiro)
		
		enquanto (estado_pong != SAIR_PONG)
		{
			inteiro estado_anterior = estado_pong

			escolha (estado_pong)
			{
				caso MENU_PONG:
					desenhar_menu_pong()
					processar_entrada_menu_pong()
					pare
				
				caso JOGANDO_PONG:
					loop_jogo_pong()
					pare
				
				caso UPGRADES_PONG:
					desenhar_upgrades_pong()
					processar_entrada_upgrades_pong()
					pare
			}
			
			// Se a tela mudou nesta volta (ex.: Menu -> Jogo), o buffer ainda tem o desenho
			// da tela anterior; apresentá-lo causava um "flash". A próxima volta já desenha certo.
			se (estado_pong == estado_anterior)
			{
				g.renderizar()
			}
			u.aguarde(16)
		}
		
		se (canal_lobby != -1)
		{
			sm.interromper_som(canal_lobby)
			canal_lobby = -1
		}
		se (canal_jogo != -1)
		{
			sm.interromper_som(canal_jogo)
			canal_jogo = -1
		}

		// Devolve a memória de tudo que o Pong carregou
		liberar_recursos_pong()

		g.sair_modo_tela_cheia()
		g.definir_dimensoes_janela(785, 1024)
		g.definir_fonte_texto("Poetsen One")
		g.definir_titulo_janela("Menu de Opções")
		m.exibir_cursor()
	}

	funcao inteiro liberar_imagem_pong(inteiro imagem)
	{
		se (imagem != -1) g.liberar_imagem(imagem)
		retorne -1
	}

	funcao inteiro liberar_som_pong(inteiro som)
	{
		se (som != -1) sm.liberar_som(som)
		retorne -1
	}

	// Libera todas as imagens e sons do Pong. Sem isso, cada vez que o jogo era aberto
	// tudo era carregado de novo e a versão anterior ficava presa na memória.
	funcao liberar_recursos_pong()
	{
		img_batedor1 = liberar_imagem_pong(img_batedor1)
		img_batedor1_meio = liberar_imagem_pong(img_batedor1_meio)
		img_batedor1_fim = liberar_imagem_pong(img_batedor1_fim)
		img_batedor2 = liberar_imagem_pong(img_batedor2)
		img_batedor2_meio = liberar_imagem_pong(img_batedor2_meio)
		img_batedor2_fim = liberar_imagem_pong(img_batedor2_fim)
		bola_beisebol = liberar_imagem_pong(bola_beisebol)

		imagem_fundo_menu_pong = liberar_imagem_pong(imagem_fundo_menu_pong)
		imagem_fundo_pong = liberar_imagem_pong(imagem_fundo_pong)
		portugol = liberar_imagem_pong(portugol)
		botao_habilidade1 = liberar_imagem_pong(botao_habilidade1)
		botao_habilidade2 = liberar_imagem_pong(botao_habilidade2)
		imagem_pausa = liberar_imagem_pong(imagem_pausa)

		som_lobby = liberar_som_pong(som_lobby)
		som_jogo = liberar_som_pong(som_jogo)
		colision_music = liberar_som_pong(colision_music)
	}

	funcao resetar_bolinha()
	{
		se (tela_w > 1400) passo = 4
		bolinha[X] = campo[X] + campo[LARGURIA]/2
		bolinha[ARTURIA] = tamanho_tile
		bolinha[LARGURIA] = tamanho_tile
		bolinha[Y] = campo[Y] + campo[ARTURIA]/2
		bolinha[V_HORIZONTAL] = 0
		bolinha[V_VERTICAL] = 0
		bolinha[ACELERACAO] = 1
		max_vel = passo + 3
		enquanto (bolinha[V_HORIZONTAL] == 0 ou bolinha[V_VERTICAL] == 0)
		{
			bolinha[V_HORIZONTAL] = u.sorteia(passo-2, passo) * u.sorteia(-1, 1)
			bolinha[V_VERTICAL] = (max_vel - mat.valor_absoluto(bolinha[V_HORIZONTAL])) * u.sorteia(-1, 1)
		}
	}

	funcao reset_game()
	{
		player1[PONTUACAO_PONG] = 0
		player2[PONTUACAO_PONG] = 0
		resetar_bolinha()
		reset_pontuacao()

		// Reinicia os usos das habilidades ativas para 3 (se estiverem compradas)
		para (inteiro i = 1; i <= 3; i++)
		{
			se (lvl_upg_p1[i] == 1) usos_p1[i] = 3
			se (lvl_upg_p2[i] == 1) usos_p2[i] = 3
		}
		// Reseta efeitos
		efeito_velocidade_p1 = falso
		efeito_confusao_p1 = falso
		efeito_congelamento_p1 = falso
		efeito_velocidade_p2 = falso
		efeito_confusao_p2 = falso
		efeito_congelamento_p2 = falso
		confusao_p1 = falso
		confusao_p2 = falso
		velocidade_atual_p1 = velocidade_base_p1
		velocidade_atual_p2 = velocidade_base_p2
		fator_congelamento_global = 1.0
		tempo_congelamento_global = 0
		tempo_velocidade_p1 = 0
		tempo_confusao_p1 = 0
		tempo_congelamento_p1 = 0
		tempo_velocidade_p2 = 0
		tempo_confusao_p2 = 0
		tempo_congelamento_p2 = 0
	}

	funcao gerar_fundo()
	{
		g.definir_cor(cor_fundo)
		g.limpar()
		g.definir_cor(cor_principal)
		desenhar_fundo()
	}

	// A pontuação é desenhada a cada quadro por desenhar_pontuacao(). Esta função antes
	// pintava a tela inteira de preto no buffer e gerava uma imagem que nunca era usada,
	// o que causava um quadro piscando ao iniciar a partida e a cada ponto.
	funcao reset_pontuacao()
	{
	}

	// Antes esta função gerava 4 imagens (uma do tamanho da tela inteira) que nunca eram
	// desenhadas e nunca eram liberadas: ~1 tela de RAM perdida a cada entrada no Pong.
	funcao gerar_imagens()
	{
		gerar_fundo()
		reset_pontuacao()
	}

	// redimensionar_imagem() NÃO altera a imagem original: ela devolve o endereço de uma
	// NOVA imagem. Por isso o retorno precisa ser guardado (antes era descartado e os
	// sprites continuavam no tamanho original, diferente da hitbox).
	funcao inteiro ajustar_imagem(inteiro imagem, inteiro largura, inteiro altura)
	{
		se (imagem == -1) retorne -1
		inteiro nova_imagem = g.redimensionar_imagem(imagem, largura, altura, falso)
		se (nova_imagem != imagem) g.liberar_imagem(imagem)
		retorne nova_imagem
	}

	// Largura que mantém a proporção do sprite para a altura desejada
	funcao inteiro largura_proporcional(inteiro imagem, inteiro altura_alvo)
	{
		se (imagem == -1) retorne tamanho_tile
		inteiro altura_original = g.altura_imagem(imagem)
		se (altura_original <= 0) retorne tamanho_tile
		inteiro nova_largura = g.largura_imagem(imagem) * altura_alvo / altura_original
		se (nova_largura < 1) nova_largura = 1
		retorne nova_largura
	}

	funcao ajustar_sprites_jogadores()
	{
		inteiro altura = tamanho_tile * ALTURA_JOGADOR_TILES
		inteiro largura1 = largura_proporcional(img_batedor1, altura)
		inteiro largura2 = largura_proporcional(img_batedor2, altura)

		img_batedor1 = ajustar_imagem(img_batedor1, largura1, altura)
		img_batedor1_meio = ajustar_imagem(img_batedor1_meio, largura1, altura)
		img_batedor1_fim = ajustar_imagem(img_batedor1_fim, largura1, altura)

		img_batedor2 = ajustar_imagem(img_batedor2, largura2, altura)
		img_batedor2_meio = ajustar_imagem(img_batedor2_meio, largura2, altura)
		img_batedor2_fim = ajustar_imagem(img_batedor2_fim, largura2, altura)

		// A bolinha usa tamanho_tile como hitbox (ver resetar_bolinha)
		bola_beisebol = ajustar_imagem(bola_beisebol, tamanho_tile, tamanho_tile)

		player1[LARGURIA] = largura1
		player1[ARTURIA] = altura
		player2[LARGURIA] = largura2
		player2[ARTURIA] = altura
	}

	funcao inicializar()
	{
		g.iniciar_modo_grafico(verdadeiro)
		g.entrar_modo_tela_cheia()
		// Dá tempo da janela terminar a troca para tela cheia antes de desenhar
		u.aguarde(300)
		m.ocultar_cursor()
		
		se (nao fonte_pong_carregada)
		{
			g.carregar_fonte("pong/PressStart2P.ttf")
			fonte_pong_carregada = verdadeiro
		}
		g.definir_fonte_texto("Press Start 2P")
		g.definir_cor(g.COR_PRETO)
		g.limpar()
		g.definir_cor(g.COR_BRANCO)
		tela_w = g.largura_tela()
		tela_h = g.altura_tela()
		tamanho_fonte = tp.inteiro_para_real(tela_h)/15.0
		g.definir_tamanho_texto(tamanho_fonte)
		cadeia text = "Carregando..."
		inteiro x = tela_w/2 - (g.largura_texto(text)/2)
		inteiro y = tela_h/2 - (g.altura_texto(text)/2)
		g.desenhar_texto(x, y, text)
		g.renderizar()

		se (portugol == -1) portugol = g.carregar_imagem("pong/portugol.png")
		se (imagem_fundo_pong == -1) imagem_fundo_pong = g.carregar_imagem("pong/Fundos_e_Bola/campo.png")
		
		branco = g.COR_BRANCO
		verde = g.criar_cor(52, 229, 0)
		
		se (colision_music == -1) colision_music = sm.carregar_som("pong/Sons/colision.wav")
		sm.definir_volume(100)

		cor_fundo = g.COR_PRETO
		cor_principal = branco
		cor_secundaria = g.criar_cor(90,90,90)
	
		campo[ARTURIA] = tela_h - tela_h/6
		campo[Y] = tela_h/12
		tamanho_tile = campo[ARTURIA]/LINHAS_PONG
		campo[LARGURIA] = tamanho_tile*COLUNAS_PONG
		campo[X] = tela_w/2 - (campo[LARGURIA]/2)
		tamanho_fonte = tp.inteiro_para_real(tamanho_tile)/2.0
		pontuacao_y = campo[Y] - tamanho_tile*3
		pontuacao1_x = campo[X]
		pontuacao2_x = campo[X] + campo[LARGURIA] - tamanho_tile*2

		// Redimensiona os sprites e define LARGURIA/ARTURIA dos jogadores a partir deles,
		// assim a hitbox é exatamente do tamanho do personagem desenhado
		ajustar_sprites_jogadores()

		player1[X] = campo[X]
		player1[Y] = campo[Y] + (campo[ARTURIA]/2) - (player1[ARTURIA]/2)
		player1[PONTUACAO_PONG] = 0

		// Encostado na borda direita do campo (simétrico ao jogador 1)
		player2[X] = campo[X] + campo[LARGURIA] - player2[LARGURIA]
		player2[Y] = campo[Y] + (campo[ARTURIA]/2) - (player2[ARTURIA]/2)
		player2[PONTUACAO_PONG] = 0
		
		passo = 5
		resetar_bolinha()
		
		para (inteiro i=0; i<LINHAS_PONG; i++)
		{
			para (inteiro j=0; j<COLUNAS_PONG; j++)
			{
				se (i==0 ou i==30)
					matriz_fundo[i][j] = 1
				senao se (j==25 e i%2 == 0)
					matriz_fundo[i][j] = 2
				senao
					matriz_fundo[i][j] = 0
			}
		}
		gerar_imagens()
		u.aguarde(1000)

		se (botao_habilidade1 == -1) botao_habilidade1 = g.carregar_imagem("pong/Habilidades/Habilidade_Reb1.png")
		se (botao_habilidade2 == -1) botao_habilidade2 = g.carregar_imagem("pong/Habilidades/Habilidade_Reb2.png")

		botao1_larg = g.largura_imagem(botao_habilidade1)
		botao1_alt  = g.altura_imagem(botao_habilidade1)
		botao2_larg = g.largura_imagem(botao_habilidade2)
		botao2_alt  = g.altura_imagem(botao_habilidade2)

		botao1_x = tela_w/2 - botao1_larg - 20
		botao1_y = tela_h - botao1_alt - 50
		botao2_x = tela_w/2 + 20
		botao2_y = tela_h - botao2_alt - 50

		// Inicializa variáveis de habilidades
		para (inteiro i = 0; i < 4; i++)
		{
			usos_p1[i] = 0
			usos_p2[i] = 0
		}
		habilidade_ativa_p1 = -1
		habilidade_ativa_p2 = -1
		velocidade_base_p1 = 8
		velocidade_base_p2 = 8
		velocidade_atual_p1 = 8
		velocidade_atual_p2 = 8
		confusao_p1 = falso
		confusao_p2 = falso
		fator_congelamento_global = 1.0
		tempo_congelamento_global = 0
		efeito_velocidade_p1 = falso
		efeito_confusao_p1 = falso
		efeito_congelamento_p1 = falso
		efeito_velocidade_p2 = falso
		efeito_confusao_p2 = falso
		efeito_congelamento_p2 = falso
	}

	funcao desenhar_fundo()
	{
		para (inteiro i = 0; i < LINHAS_PONG; i++)
		{
			para (inteiro j = 0; j < COLUNAS_PONG; j++)
			{
				se (matriz_fundo[i][j] == 1)
				{
					g.definir_cor(cor_principal)
					g.desenhar_retangulo(
						campo[X] + j * tamanho_tile,
						campo[Y] + i * tamanho_tile,
						tamanho_tile,
						tamanho_tile,
						falso,
						verdadeiro
					)
				}
			}
		}
	}

	funcao desenhar_atalhos()
	{
		g.definir_tamanho_texto(15.0)
		se (tela_w > 1400) g.definir_tamanho_texto(30.0)
		g.definir_cor(cor_principal)
		inteiro y_pos = tp.real_para_inteiro(tamanho_tile * 1.5)
		se (DEMO_mode)
		{
			g.desenhar_texto(campo[X] + campo[LARGURIA] - g.largura_texto("Press any key to return"), y_pos, "Press any key to return")
		}
		senao
		{
			g.desenhar_texto(campo[X], y_pos, "P1: W/S + Space | P2: Setas + Enter")
			g.desenhar_texto(campo[X] + campo[LARGURIA] - g.largura_texto("P: pause  R: reset"), y_pos, "P: pause  R: reset")
		}
		g.definir_tamanho_texto(tp.inteiro_para_real(tela_h)/15.0)
	}

	funcao desenhar_pontuacao()
	{
		g.desenhar_texto(pontuacao1_x, pontuacao_y, player1[PONTUACAO_PONG]+"")
		g.desenhar_texto(pontuacao2_x, pontuacao_y, player2[PONTUACAO_PONG]+"")
	}

	funcao atualizar_animacao_jogador1()
	{
		se (animando1)
		{
			se (u.tempo_decorrido() - tempo_animacao1 > 50)
			{
				frame_animacao1++
				se (frame_animacao1 > 2)
				{
					frame_animacao1 = 0
					animando1 = falso
				}
				tempo_animacao1 = u.tempo_decorrido()+100
			}
		}
	}

	funcao atualizar_animacao_jogador2()
	{
		se (animando2)
		{
			se (u.tempo_decorrido() - tempo_animacao2 > 50)
			{
				frame_animacao2++
				se (frame_animacao2 > 2)
				{
					frame_animacao2 = 0
					animando2 = falso
				}
				tempo_animacao2 = u.tempo_decorrido()+100
			}
		}
	}
	
	funcao desenhar()
	
	{
		g.definir_cor(cor_fundo)
		g.limpar()
		
		se (imagem_fundo_pong != -1) {
			g.desenhar_imagem(100, 200, imagem_fundo_pong)
		}
		desenhar_fundo()
		g.definir_cor(cor_principal)
		desenhar_pontuacao()

		se (frame_animacao1 == 0){
			g.desenhar_imagem(player1[X], player1[Y], img_batedor1)
		}
		senao se (frame_animacao1 == 1)
		{
			g.desenhar_imagem(player1[X], player1[Y], img_batedor1_meio)
		}
		senao
		{
			g.desenhar_imagem(player1[X], player1[Y], img_batedor1_fim)
		}

		se (frame_animacao2 == 0){
			g.desenhar_imagem(player2[X], player2[Y], img_batedor2)
		}
		senao se (frame_animacao2 == 1)
		{
			g.desenhar_imagem(player2[X], player2[Y], img_batedor2_meio)
		}
		senao
		{
			g.desenhar_imagem(player2[X], player2[Y], img_batedor2_fim)
		}
		
		g.desenhar_imagem(bolinha[X], bolinha[Y], bola_beisebol)

		se (portugol != -1)
		{
			g.desenhar_imagem(tela_w/2 - 125, 25, portugol)
			desenhar_atalhos()
		}

		// Barras de força
		g.definir_cor(verde)
		g.desenhar_retangulo(player1[X], player1[Y], forca1*13, 10, falso, verdadeiro)
		g.desenhar_retangulo(player2[X] + player2[LARGURIA] - forca2*13, player2[Y]-15, forca2*13, 10, falso, verdadeiro)
		
		se (botao_habilidade1 != -1) {
			g.desenhar_imagem(botao1_x, botao1_y, botao_habilidade1)
		}
		se (botao_habilidade2 != -1) {
			g.desenhar_imagem(botao2_x, botao2_y, botao_habilidade2)
		}

		// Exibe informações da habilidade ativa de cada jogador
		g.definir_tamanho_texto(14.0)
		g.definir_cor(g.COR_BRANCO)
		se (habilidade_ativa_p1 != -1 e usos_p1[habilidade_ativa_p1] > 0)
		{
			cadeia txt = nomes_upgrades[habilidade_ativa_p1] + " (" + usos_p1[habilidade_ativa_p1] + ")"
			g.desenhar_texto(botao1_x, botao1_y - 30, txt)
		}
		se (habilidade_ativa_p2 != -1 e usos_p2[habilidade_ativa_p2] > 0)
		{
			cadeia txt = nomes_upgrades[habilidade_ativa_p2] + " (" + usos_p2[habilidade_ativa_p2] + ")"
			g.desenhar_texto(botao2_x, botao2_y - 30, txt)
		}
	}
	
	funcao mover()
{
    // Jogador 1 - com confusão (inverte W e S)
    se (confusao_p1)
    {
        se (t.tecla_pressionada(t.TECLA_S)) // S invertido -> sobe
        {
            se (player1[Y] - velocidade_atual_p1 >= campo[Y] + tamanho_tile)
                player1[Y] = player1[Y] - velocidade_atual_p1
        }
        se (t.tecla_pressionada(t.TECLA_W)) // W invertido -> desce
        {
            se (player1[Y] + velocidade_atual_p1 + player1[ARTURIA] < campo[Y] + campo[ARTURIA] - tamanho_tile)
                player1[Y] = player1[Y] + velocidade_atual_p1
        }
    }
    senao
    {
        // Controles normais
        se (t.tecla_pressionada(t.TECLA_S))
        {
            se (player1[Y] + velocidade_atual_p1 + player1[ARTURIA] < campo[Y] + campo[ARTURIA] - tamanho_tile)
                player1[Y] = player1[Y] + velocidade_atual_p1
        }
        se (t.tecla_pressionada(t.TECLA_W))
        {
            se (player1[Y] - velocidade_atual_p1 >= campo[Y] + tamanho_tile)
                player1[Y] = player1[Y] - velocidade_atual_p1
        }
    }

    // Jogador 2 - com confusão (inverte setas)
    se (confusao_p2)
    {
        se (t.tecla_pressionada(t.TECLA_SETA_ABAIXO)) // seta baixo invertida -> sobe
        {
            se (player2[Y] - velocidade_atual_p2 >= campo[Y] + tamanho_tile)
                player2[Y] = player2[Y] - velocidade_atual_p2
        }
        se (t.tecla_pressionada(t.TECLA_SETA_ACIMA)) // seta cima invertida -> desce
        {
            se (player2[Y] + velocidade_atual_p2 + player2[ARTURIA] < campo[Y] + campo[ARTURIA] - tamanho_tile)
                player2[Y] = player2[Y] + velocidade_atual_p2
        }
    }
    senao
    {
        // Controles normais
        se (t.tecla_pressionada(t.TECLA_SETA_ABAIXO))
        {
            se (player2[Y] + velocidade_atual_p2 + player2[ARTURIA] < campo[Y] + campo[ARTURIA] - tamanho_tile)
                player2[Y] = player2[Y] + velocidade_atual_p2
        }
        se (t.tecla_pressionada(t.TECLA_SETA_ACIMA))
        {
            se (player2[Y] - velocidade_atual_p2 >= campo[Y] + tamanho_tile)
                player2[Y] = player2[Y] - velocidade_atual_p2
        }
    }
}
	
	funcao mover_bolinha()
	{
		bolinha[X] = bolinha[X] + tp.real_para_inteiro(bolinha[V_HORIZONTAL] * fator_congelamento_global)
		bolinha[Y] = bolinha[Y] + tp.real_para_inteiro(bolinha[V_VERTICAL] * fator_congelamento_global)
	}

	funcao rebater_jogador1()
	{
		se (bolinha[V_HORIZONTAL] < 0 e
		    bolinha[X] < player1[X] + player1[LARGURIA] e
		    bolinha[X] + bolinha[LARGURIA] > player1[X] e
		    bolinha[Y] + bolinha[ARTURIA] > player1[Y] e
		    bolinha[Y] < player1[Y] + player1[ARTURIA])
		{
			bolinha[V_HORIZONTAL] = mat.valor_absoluto(bolinha[V_HORIZONTAL]) + forca1

			se (lvl_upg_p1[0] > 0)
			{
				inteiro max_vel_aleatoria = max_vel + lvl_upg_p1[0] * 2
				inteiro direcao_v = u.sorteia(-1, 1)
				enquanto (direcao_v == 0) { direcao_v = u.sorteia(-1, 1) }
				bolinha[V_VERTICAL] = u.sorteia(passo - 2, max_vel_aleatoria) * direcao_v
			}	

			colision_play = sm.reproduzir_som(colision_music, falso)
			sm.definir_volume_reproducao(colision_play, 100)
			forca1 = 0

			batidas_p1 = batidas_p1 + 1
			se (batidas_p1 == 3) {
				strikecoins_p1 = strikecoins_p1 + 1
				batidas_p1 = 0
			}

			animando1 = verdadeiro
			frame_animacao1 = 0
			tempo_animacao1 = u.tempo_decorrido()
		}
	}

	funcao rebater_jogador2()
	{
		se (bolinha[V_HORIZONTAL] > 0 e
		    bolinha[X] + bolinha[LARGURIA] > player2[X] e
		    bolinha[X] < player2[X] + player2[LARGURIA] e
		    bolinha[Y] + bolinha[ARTURIA] > player2[Y] e
		    bolinha[Y] < player2[Y] + player2[ARTURIA])
		{
			bolinha[V_HORIZONTAL] = -(mat.valor_absoluto(bolinha[V_HORIZONTAL]) + forca2)

			se (lvl_upg_p2[0] > 0)
			{
				inteiro max_vel_aleatoria = max_vel + lvl_upg_p2[0] * 2
				inteiro direcao_v = u.sorteia(-1, 1)
				enquanto (direcao_v == 0) { direcao_v = u.sorteia(-1, 1) }
				bolinha[V_VERTICAL] = u.sorteia(passo - 2, max_vel_aleatoria) * direcao_v
			}

			colision_play = sm.reproduzir_som(colision_music, falso)
			sm.definir_volume_reproducao(colision_play, 100)
			forca2 = 0

			batidas_p2 = batidas_p2 + 1
			se (batidas_p2 == 3) {
				strikecoins_p2 = strikecoins_p2 + 1
				batidas_p2 = 0
			}
			
			animando2 = verdadeiro
			frame_animacao2 = 0
			tempo_animacao2 = u.tempo_decorrido()
		}
	}

	funcao colisoes()
	{
		se (bolinha[Y] < campo[Y] + tamanho_tile ou bolinha[Y] + bolinha[ARTURIA] > campo[Y] + campo[ARTURIA] - tamanho_tile)
		{
			bolinha[Y] = bolinha[Y] - bolinha[V_VERTICAL]
			bolinha[V_VERTICAL] = bolinha[V_VERTICAL] * -1
			colision_play = sm.reproduzir_som(colision_music, falso)
			sm.definir_volume_reproducao(colision_play, 100)
		}
		
		rebater_jogador1()
		rebater_jogador2()
	}

	funcao pontuar()
	{
		se (bolinha[X] < campo[X] - bolinha[LARGURIA])
		{
			player2[PONTUACAO_PONG]++
			reset_pontuacao()
			resetar_bolinha()
		}
		se (bolinha[X] > campo[X] + campo[LARGURIA] + bolinha[LARGURIA])
		{
			player1[PONTUACAO_PONG]++
			reset_pontuacao()
			resetar_bolinha()
		}
	}

	funcao atalhos()
	{
		se (t.tecla_pressionada(t.TECLA_P))
		{
			pausado = verdadeiro
			desenhar()
			imagem_pausa = liberar_imagem_pong(imagem_pausa)
			imagem_pausa = g.renderizar_imagem(tela_w, tela_h)
			enquanto (t.tecla_pressionada(t.TECLA_P)) { }
		}
		se (t.tecla_pressionada(t.TECLA_R))
		{
			reset_game()
			enquanto (t.tecla_pressionada(t.TECLA_R)) { }
		}
		enquanto (pausado)
		{
			g.definir_cor(cor_fundo)
			g.limpar()
			g.definir_cor(cor_principal)
			g.definir_opacidade(100)
			g.desenhar_imagem(0, 0, imagem_pausa)
			g.definir_opacidade(255)
			g.desenhar_texto(tela_w/2 - g.largura_texto("Pausado")/2, tela_h/2 - g.altura_texto("Pausado")/2, "Pausado")
			g.renderizar()
			se (t.tecla_pressionada(t.TECLA_P))
			{
				pausado = falso
				enquanto (t.tecla_pressionada(t.TECLA_P)) { }
			}
		}
		// Saiu da pausa: a captura da tela não é mais necessária
		imagem_pausa = liberar_imagem_pong(imagem_pausa)
	}

	// ========== FUNÇÕES DE HABILIDADES ATIVAS ==========
	funcao ativar_habilidade(inteiro jogador)
{
    se (jogador == 1)
    {
        se (habilidade_ativa_p1 == -1) retorne
        inteiro idx = habilidade_ativa_p1
        se (usos_p1[idx] <= 0) retorne

        escolha (idx)
        {
            caso 1: // Aumento de Velocidade
                efeito_velocidade_p1 = verdadeiro
                tempo_velocidade_p1 = DURACAO_EFEITO
                velocidade_atual_p1 = tp.real_para_inteiro(velocidade_base_p1 * FATOR_VELOCIDADE)
                pare
            caso 2: // Confusão
                efeito_confusao_p2 = verdadeiro
                tempo_confusao_p2 = DURACAO_EFEITO
                confusao_p2 = verdadeiro
                pare
            caso 3: // Congelamento
                efeito_congelamento_p1 = verdadeiro
                tempo_congelamento_global = DURACAO_EFEITO
                fator_congelamento_global = FATOR_CONGELAMENTO
                pare
        }
        usos_p1[idx]--

        // SE OS USOS ZERAREM, DESCOMPRA A HABILIDADE
        se (usos_p1[idx] == 0)
        {
            lvl_upg_p1[idx] = 0
            habilidade_ativa_p1 = -1
        }
    }
      senao se (jogador == 2)
    {
        se (habilidade_ativa_p2 == -1) retorne
        inteiro idx = habilidade_ativa_p2
        se (usos_p2[idx] <= 0) retorne

        escolha (idx)
        {
            caso 1: // Aumento de Velocidade (afeta o próprio jogador 2)
                efeito_velocidade_p2 = verdadeiro
                tempo_velocidade_p2 = DURACAO_EFEITO
                velocidade_atual_p2 = tp.real_para_inteiro(velocidade_base_p2 * FATOR_VELOCIDADE)
                pare
            caso 2: // Confusão (afeta o jogador 1)
                efeito_confusao_p1 = verdadeiro
                tempo_confusao_p1 = DURACAO_EFEITO
                confusao_p1 = verdadeiro
                pare
            caso 3: // Congelamento (afeta a bola globalmente)
                efeito_congelamento_p2 = verdadeiro
                tempo_congelamento_global = DURACAO_EFEITO
                fator_congelamento_global = FATOR_CONGELAMENTO
                pare
        }
        usos_p2[idx]--
        se (usos_p2[idx] == 0)
        {
            lvl_upg_p2[idx] = 0
            habilidade_ativa_p2 = -1
        }
    }
}

	funcao atualizar_efeitos()
	{
		// Atualiza temporizadores e desativa efeitos quando expiram
		se (efeito_velocidade_p1)
		{
			tempo_velocidade_p1 = tempo_velocidade_p1 - 16
			se (tempo_velocidade_p1 <= 0)
			{
				efeito_velocidade_p1 = falso
				velocidade_atual_p1 = velocidade_base_p1
			}
		}
		se (efeito_velocidade_p2)
		{
			tempo_velocidade_p2 = tempo_velocidade_p2 - 16
			se (tempo_velocidade_p2 <= 0)
			{
				efeito_velocidade_p2 = falso
				velocidade_atual_p2 = velocidade_base_p2
			}
		}
		se (confusao_p1)
    {
        tempo_confusao_p1 = tempo_confusao_p1 - 16
        se (tempo_confusao_p1 <= 0)
        {
            confusao_p1 = falso
            efeito_confusao_p1 = falso
        }
    }
    se (confusao_p2)
    {
        tempo_confusao_p2 = tempo_confusao_p2 - 16
        se (tempo_confusao_p2 <= 0)
        {
            confusao_p2 = falso
            efeito_confusao_p2 = falso
        }
    }
		se (fator_congelamento_global < 1.0)
		{
			tempo_congelamento_global = tempo_congelamento_global - 16
			se (tempo_congelamento_global <= 0)
			{
				fator_congelamento_global = 1.0
				efeito_congelamento_p1 = falso
				efeito_congelamento_p2 = falso
			}
		}
	}
	// =================================================
 
	// Espera soltar ENTER/ESC para a mesma tecla não ser lida duas vezes
	// (ex.: ENTER do menu virando "carregar força" do jogador 2, ou voltando do Upgrades na hora)
	funcao aguardar_soltar_enter_esc()
	{
		enquanto (t.tecla_pressionada(t.TECLA_ENTER) ou t.tecla_pressionada(t.TECLA_ESC))
		{
			u.aguarde(10)
		}
	}

	funcao desenhar_menu_pong()
	{
		// Sempre limpa antes: sem isso sobravam pedaços do quadro anterior (piscando)
		g.definir_cor(g.COR_PRETO)
		g.limpar()
		se (imagem_fundo_menu_pong != -1)
			g.desenhar_imagem(0, 0, imagem_fundo_menu_pong)
		
		g.definir_cor(g.COR_BRANCO)
		g.definir_tamanho_texto(40.0)
		cadeia titulo = "PONG"
		inteiro x_titulo = tela_w/2 - g.largura_texto(titulo)/2
		g.desenhar_texto(x_titulo, 150, titulo)
		
		g.definir_tamanho_texto(28.0)
		cadeia opcoes[] = {"Jogar", "Upgrades"}
		para (inteiro i = 0; i < 2; i++)
		{
			inteiro cor
			se (opcao_menu_pong == i)
				cor = g.COR_AMARELO
			senao
				cor = g.COR_BRANCO
			
			g.definir_cor(cor)
			inteiro x = tela_w/2 - g.largura_texto(opcoes[i])/2
			inteiro y = 300 + i * 80
			g.desenhar_texto(x, y, opcoes[i])
			
			se (opcao_menu_pong == i)
			{
				g.desenhar_texto(x - 60, y, "►")
				g.desenhar_texto(x + g.largura_texto(opcoes[i]) + 20, y, "◄")
			}
		}
		
		g.definir_cor(g.COR_VERDE)
		g.definir_tamanho_texto(16.0)
		cadeia ajuda = "Use ↑/↓ para navegar e ENTER para selecionar"
		inteiro x_ajuda = tela_w/2 - g.largura_texto(ajuda)/2
		g.desenhar_texto(x_ajuda, tela_h - 80, ajuda)
	}

	funcao processar_entrada_menu_pong()
	{
		se (t.tecla_pressionada(t.TECLA_SETA_ACIMA) ou t.tecla_pressionada(t.TECLA_W))
		{
			opcao_menu_pong = (opcao_menu_pong - 1 + 2) % 2
			u.aguarde(150)
		}
		senao se (t.tecla_pressionada(t.TECLA_SETA_ABAIXO) ou t.tecla_pressionada(t.TECLA_S))
		{
			opcao_menu_pong = (opcao_menu_pong + 1) % 2
			u.aguarde(150)
		}
		senao se (t.tecla_pressionada(t.TECLA_ENTER))
		{
			se (opcao_menu_pong == 0)
			{
				se (canal_lobby != -1)
				{
					sm.interromper_som(canal_lobby)
					canal_lobby = -1
				}
				se (canal_jogo == -1)
					canal_jogo = sm.reproduzir_som(som_jogo, verdadeiro)

				reset_game()
				estado_pong = JOGANDO_PONG
			}
			senao
			{
				estado_pong = UPGRADES_PONG
			}
			u.aguarde(200)
			aguardar_soltar_enter_esc()
		}
		senao se (t.tecla_pressionada(t.TECLA_ESC))
		{
			estado_pong = SAIR_PONG
			u.aguarde(200)
		}
	}

	funcao desenhar_upgrades_pong()
	{
		g.definir_cor(g.COR_PRETO)
		g.limpar()

		g.definir_cor(g.COR_AMARELO)
		g.definir_tamanho_texto(36.0)
		cadeia titulo = "MELHORIAS (UPGRADES)"
		inteiro x_titulo = tela_w / 2 - g.largura_texto(titulo) / 2
		g.desenhar_texto(x_titulo, 50, titulo)

		inteiro x_coluna1 = tela_w * 0.08
		inteiro x_coluna2 = tela_w * 0.55

		g.definir_tamanho_texto(18.0)
		g.definir_cor(g.COR_BRANCO)
		g.desenhar_texto(x_coluna1, 130, "P1 (W/S para mover | D para Comprar)")
		g.definir_cor(g.COR_AMARELO)
		g.desenhar_texto(x_coluna1, 160, "Banco: " + strikecoins_p1 + " Strikecoins")	

		g.definir_cor(g.COR_BRANCO)
		g.desenhar_texto(x_coluna2, 130, "P2 (Setas para mover | DIR para Comprar)")
		g.definir_cor(g.COR_AMARELO)
		g.desenhar_texto(x_coluna2, 160, "Banco: " + strikecoins_p2 + " Strikecoins")

		inteiro y_base = 230
		inteiro espacamento_y = 75

		para (inteiro i = 0; i < 4; i++)
		{
			inteiro y_pos = y_base + (i * espacamento_y)

			// Jogador 1
			se (sel_upg_p1 == i)
				g.definir_cor(g.COR_VERDE)
			senao
				g.definir_cor(g.COR_BRANCO)

			cadeia item_p1
			se (i == 0) // Rebatida Aleatória (passiva)
			{
				item_p1 = (i+1) + ". " + nomes_upgrades[i] + " (Nvl: " + lvl_upg_p1[i] + "/" + NIVEL_MAX_REBATIDA + ")"
				g.desenhar_texto(x_coluna1, y_pos, item_p1)
				g.definir_cor(g.COR_VERMELHO)
				se (lvl_upg_p1[i] >= NIVEL_MAX_REBATIDA)
					g.desenhar_texto(x_coluna1, y_pos + 25, "Já comprada")
				senao
					g.desenhar_texto(x_coluna1, y_pos + 25, "Custo: " + custo_upg[i] + " Strikecoins")
			}
			senao // Habilidades ativas (1,2,3)
			{
				se (lvl_upg_p1[i] == 0)
					item_p1 = (i+1) + ". " + nomes_upgrades[i] + " (Comprar)"
				senao
					item_p1 = (i+1) + ". " + nomes_upgrades[i] + " (Comprada, usos: " + usos_p1[i] + ")"
				g.desenhar_texto(x_coluna1, y_pos, item_p1)
				g.definir_cor(g.COR_VERMELHO)
				se (lvl_upg_p1[i] == 0)
					g.desenhar_texto(x_coluna1, y_pos + 25, "Custo: " + custo_upg[i] + " Strikecoins")
				senao
					g.desenhar_texto(x_coluna1, y_pos + 25, "Já comprada")
			}

			// Jogador 2
			se (sel_upg_p2 == i)
				g.definir_cor(g.COR_VERDE)
			senao
				g.definir_cor(g.COR_BRANCO)

			cadeia item_p2
			se (i == 0)
			{
				item_p2 = (i+1) + ". " + nomes_upgrades[i] + " (Nvl: " + lvl_upg_p2[i] + "/" + NIVEL_MAX_REBATIDA + ")"
				g.desenhar_texto(x_coluna2, y_pos, item_p2)
				g.definir_cor(g.COR_VERMELHO)
				se (lvl_upg_p2[i] >= NIVEL_MAX_REBATIDA)
					g.desenhar_texto(x_coluna2, y_pos + 25, "Já comprada")
				senao
					g.desenhar_texto(x_coluna2, y_pos + 25, "Custo: " + custo_upg[i] + " Strikecoins")
			}
			senao
			{
				se (lvl_upg_p2[i] == 0)
					item_p2 = (i+1) + ". " + nomes_upgrades[i] + " (Comprar)"
				senao
					item_p2 = (i+1) + ". " + nomes_upgrades[i] + " (Comprada, usos: " + usos_p2[i] + ")"
				g.desenhar_texto(x_coluna2, y_pos, item_p2)
				g.definir_cor(g.COR_VERMELHO)
				se (lvl_upg_p2[i] == 0)
					g.desenhar_texto(x_coluna2, y_pos + 25, "Custo: " + custo_upg[i] + " Strikecoins")
				senao
					g.desenhar_texto(x_coluna2, y_pos + 25, "Já comprada")
			}
		}

		g.definir_cor(g.COR_VERDE)
		g.definir_tamanho_texto(22.0)
		cadeia rodape = "Pressione ENTER para Voltar"
		inteiro x_rodape = tela_w / 2 - g.largura_texto(rodape) / 2
		g.desenhar_texto(x_rodape, tela_h - 70, rodape)
	}

	funcao processar_entrada_upgrades_pong()
{
    // ===================== JOGADOR 1 =====================
    se (t.tecla_pressionada(t.TECLA_W))
    {
        sel_upg_p1 = (sel_upg_p1 - 1 + 4) % 4
        u.aguarde(150)
    }
    senao se (t.tecla_pressionada(t.TECLA_S))
    {
        sel_upg_p1 = (sel_upg_p1 + 1) % 4
        u.aguarde(150)
    }
    senao se (t.tecla_pressionada(t.TECLA_D))
    {
        inteiro i = sel_upg_p1
        se (i >= 1 e i <= 3) // Habilidades ativas: 1=Velocidade, 2=Confusão, 3=Congelamento
        {
            // Verifica se o jogador 1 já possui alguma habilidade ativa
            logico ja_tem_ativa = falso
            para (inteiro j = 1; j <= 3; j++)
            {
                se (lvl_upg_p1[j] == 1) { ja_tem_ativa = verdadeiro pare }
            }
            // Só compra se não tiver ativa, a habilidade ainda não foi comprada e tem saldo
            se (nao ja_tem_ativa e lvl_upg_p1[i] == 0 e strikecoins_p1 >= custo_upg[i])
            {
                strikecoins_p1 = strikecoins_p1 - custo_upg[i]
                lvl_upg_p1[i] = 1
                usos_p1[i] = 3
                habilidade_ativa_p1 = i
            }
        }
        senao se (i == 0) // Rebatida Aleatória (passiva) – só até NIVEL_MAX_REBATIDA
        {
            se (lvl_upg_p1[0] < NIVEL_MAX_REBATIDA e strikecoins_p1 >= custo_upg[0])
            {
                strikecoins_p1 = strikecoins_p1 - custo_upg[0]
                lvl_upg_p1[0] = lvl_upg_p1[0] + 1
            }
        }
        u.aguarde(200)
    }

    // ===================== JOGADOR 2 =====================
    se (t.tecla_pressionada(t.TECLA_SETA_ACIMA))
    {
        sel_upg_p2 = (sel_upg_p2 - 1 + 4) % 4
        u.aguarde(150)
    }
    senao se (t.tecla_pressionada(t.TECLA_SETA_ABAIXO))
    {
        sel_upg_p2 = (sel_upg_p2 + 1) % 4
        u.aguarde(150)
    }
    senao se (t.tecla_pressionada(t.TECLA_SETA_DIREITA))
    {
        inteiro i = sel_upg_p2
        se (i >= 1 e i <= 3)
        {
            logico ja_tem_ativa = falso
            para (inteiro j = 1; j <= 3; j++)
            {
                se (lvl_upg_p2[j] == 1) { ja_tem_ativa = verdadeiro pare }
            }
            se (nao ja_tem_ativa e lvl_upg_p2[i] == 0 e strikecoins_p2 >= custo_upg[i])
            {
                strikecoins_p2 = strikecoins_p2 - custo_upg[i]
                lvl_upg_p2[i] = 1
                usos_p2[i] = 3
                habilidade_ativa_p2 = i
            }
        }
        senao se (i == 0)
        {
            se (lvl_upg_p2[0] < NIVEL_MAX_REBATIDA e strikecoins_p2 >= custo_upg[0])
            {
                strikecoins_p2 = strikecoins_p2 - custo_upg[0]
                lvl_upg_p2[0] = lvl_upg_p2[0] + 1
            }
        }
        u.aguarde(200)
    }

    // ===================== SAIR =====================
    se (t.tecla_pressionada(t.TECLA_ENTER) ou t.tecla_pressionada(t.TECLA_ESC))
    {
        estado_pong = MENU_PONG
        u.aguarde(200)
        aguardar_soltar_enter_esc()
    }
}

	funcao loop_jogo_pong()
	{
		enquanto (estado_pong == JOGANDO_PONG)
		{
			controle()
			desenhar()
			g.renderizar()

			// Verifica clique nos botões de habilidade
			se (m.botao_pressionado(m.BOTAO_ESQUERDO)) {
				inteiro mouse_x = m.posicao_x()
				inteiro mouse_y = m.posicao_y()

				se (mouse_x >= botao1_x e mouse_x <= botao1_x + botao1_larg e
					mouse_y >= botao1_y e mouse_y <= botao1_y + botao1_alt) {
					ativar_habilidade(1)
					u.aguarde(200)
				}
				se (mouse_x >= botao2_x e mouse_x <= botao2_x + botao2_larg e
					mouse_y >= botao2_y e mouse_y <= botao2_y + botao2_alt) {
					ativar_habilidade(2)
					u.aguarde(200)
				}
			} 
			u.aguarde(16)
			
			se (t.tecla_pressionada(t.TECLA_ESC))
			{
				se (canal_jogo != -1)
				{
					sm.interromper_som(canal_jogo)
					canal_jogo = -1
				}
				se (canal_lobby == -1)
					canal_lobby = sm.reproduzir_som(som_lobby, verdadeiro)

				estado_pong = MENU_PONG
				enquanto (t.tecla_pressionada(t.TECLA_ESC)) { }
			}
		}
	}
		
	funcao controle()
	{
		atualizar_animacao_jogador1()
		atualizar_animacao_jogador2()
		atualizar_efeitos()  // Atualiza temporizadores e desativa efeitos

		mover()
		
		// Lógica de carga e rebatida para o Jogador 1 (ESPAÇO)
		se (t.tecla_pressionada(t.TECLA_ESPACO))
		{
			carregando1 = verdadeiro
			se (forca1 < FORCA_MAX) forca1 = forca1 + 1
		}
		senao
		{
			se (carregando1)
			{
				rebater_jogador1()
			}
			carregando1 = falso
		}
		
		// Lógica de carga e rebatida para o Jogador 2 (ENTER)
		se (t.tecla_pressionada(t.TECLA_ENTER))
		{
			carregando2 = verdadeiro
			se (forca2 < FORCA_MAX) forca2 = forca2 + 1
		}
		senao
		{
			se (carregando2)
			{
				rebater_jogador2()
			}
			carregando2 = falso
		}

		inteiro agora = u.tempo_decorrido()
    se (t.tecla_pressionada(t.TECLA_E) e agora - ultimo_uso_habilidade >= 300)
    {
        ativar_habilidade(1)   // Jogador 1 ativa a Confusão (afeta o P2)
        ultimo_uso_habilidade = agora
    }
    se (t.tecla_pressionada(t.TECLA_0) e agora - ultimo_uso_habilidade >= 300)
    {
        ativar_habilidade(2)   // Jogador 2 ativa a Confusão (afeta o P1)
        ultimo_uso_habilidade = agora
    }
		colisoes()
		mover_bolinha()
		pontuar()
		atalhos()
	}

	// -------------------------------------------------------------
	// Funções do Jogo de Corrida
	// -------------------------------------------------------------

	funcao executar_jogo_corrida()
	{
		inicializar_banco_skins()
		inicializar_jogo()

		sm.reproduzir_som(som_ligar, falso)

		enquanto (verdadeiro)
		{
			se (estado_jogo == ESTADO_MENU e t.tecla_pressionada(t.TECLA_ESC)){
				parar_todas_musicas()
				retorne
			}
			limpar_tela()

			escolha (estado_jogo)
			{
				caso ESTADO_MENU:
					gerenciar_musica_menu()
					atualizar_estrada_menu()
					desenhar_menu()
					processar_entrada_menu()
					pare

				caso ESTADO_SKINS:
					gerenciar_musica_menu()
					atualizar_estrada_menu()
					desenhar_skins()
					processar_entrada_skins()
					pare

				caso ESTADO_MELHORIAS:
					gerenciar_musica_menu()
					atualizar_estrada_menu()
					desenhar_melhorias()
					processar_entrada_melhorias()
					pare

				caso ESTADO_JOGANDO:
					gerenciar_musica_jogo()
					atualizar_jogo()
					desenhar_jogo()
					pare

				caso ESTADO_GAME_OVER:
					parar_todas_musicas()
					desenhar_game_over()
					processar_entrada_game_over()
					pare
			}

			g.renderizar()
			u.aguarde(16)
		}
	}

	funcao gerenciar_musica_menu()
	{
		se (nao musica_menu_tocando)
		{
			parar_todas_musicas()
			sm.reproduzir_som(musica_menu, verdadeiro)
			musica_menu_tocando = verdadeiro
		}
	}

	funcao gerenciar_musica_jogo()
	{
		se (nao musica_jogo_tocando)
		{
			parar_todas_musicas()
			sm.reproduzir_som(musica_jogo, verdadeiro)
			sm.reproduzir_som(som_trafego, verdadeiro)
			musica_jogo_tocando = verdadeiro
		}
	}

	funcao parar_todas_musicas()
	{
		se (musica_menu_tocando)
		{
			sm.interromper_som(musica_menu)
			musica_menu_tocando = falso
		}
		se (musica_jogo_tocando)
		{
			sm.interromper_som(musica_jogo)
			sm.interromper_som(som_trafego)
			musica_jogo_tocando = falso
		}
	}

	funcao inicializar_banco_skins()
	{
		para(inteiro i = 0; i < 24; i++)
		{
			skins_desbloqueadas_p1[i] = falso
			skins_desbloqueadas_p2[i] = falso
		}
		skins_desbloqueadas_p1[0] = verdadeiro 
		skins_desbloqueadas_p2[1] = verdadeiro 
		jogador1[_MODELO] = 0
		jogador2[_MODELO] = 1
	}

	funcao inicializar_jogo()
	{
		g.iniciar_modo_grafico(verdadeiro)
		g.definir_dimensoes_janela(LARGURA, ALTURA)
		g.definir_titulo_janela("Corrida - 2 Jogadores")

		carregar_imagens()
		carregar_sons()
		inicializar_elementos()
	}

	funcao carregar_imagens()
	{
		imagem_estrada = g.carregar_imagem("corrida/imagens/estrada.jpg") 
		imagem_veiculos = g.carregar_imagem("corrida/imagens/veiculos.png") 
		imagem_estrela = g.carregar_imagem("corrida/imagens/estrela.png")
		imagem_objetos = g.carregar_imagem("corrida/imagens/objetos.png")
		imagem_logo = g.carregar_imagem("corrida/imagens/watermarked_img_12591174065783305559-removebg-preview.png")
		imagem_fundo_menu = g.carregar_imagem("corrida/imagens/1111.jpg") 
	}

	funcao carregar_sons()
	{
		musica_jogo            = sm.carregar_som("corrida/sons/musica_jogo.mp3")
		musica_menu            = sm.carregar_som("corrida/sons/musica_menu.mp3")
		som_alarme_combustivel = sm.carregar_som("corrida/sons/som_alarme_combustivel.mp3")
		som_colisao            = sm.carregar_som("corrida/sons/som_colisao.mp3")
		som_combustivel        = sm.carregar_som("corrida/sons/som_combustivel.mp3")
		som_freio              = sm.carregar_som("corrida/sons/som_freio.mp3")
		som_largada            = sm.carregar_som("corrida/sons/som_largada.mp3")
		som_ligar              = sm.carregar_som("corrida/sons/som_ligar.mp3")
		som_reparo             = sm.carregar_som("corrida/sons/som_reparo.mp3")
		som_trafego            = sm.carregar_som("corrida/sons/som_trafego.mp3")
	}

	funcao inicializar_elementos()
	{
		pontuacao_p1 = 0.0
		pontuacao_p2 = 0.0
		velocidade_p1 = 12.0
		velocidade_p2 = 12.0
		estrelas_p1_qtd = 0 
		estrelas_p2_qtd = 0
		jogador1_vivo = verdadeiro
		jogador2_vivo = verdadeiro
		deslocamento_estrada = 0.0
		combustivel_p1 = MAXIMO_COMBUSTIVEL
		combustivel_p2 = MAXIMO_COMBUSTIVEL
		alarme_p1_tocado = falso
		alarme_p2_tocado = falso
		vidas_p1 = nivel_vida_p1
		vidas_p2 = nivel_vida_p2

		para (inteiro i = 0; i < u.numero_linhas(inimigos_p1); i++)
		{
			inimigos_p1[i][_Y] = -1000
			sortear_posicao_veiculo(inimigos_p1, i, 0)
		}

		para (inteiro i = 0; i < u.numero_linhas(inimigos_p2); i++)
		{
			inimigos_p2[i][_Y] = -1000
			sortear_posicao_veiculo(inimigos_p2, i, 400)
		}

		para (inteiro i = 0; i < u.numero_linhas(estrelas_p1); i++)
		{
			reiniciar_estrela(estrelas_p1, i, 0)
			reiniciar_estrela(estrelas_p2, i, 400)
			
			reiniciar_galao(galoes_p1, i, 0)
			reiniciar_galao(galoes_p2, i, 400)
		}

		reiniciar_jogadores()
	}

	funcao reiniciar_jogadores()
	{
		inteiro m1 = jogador1[_MODELO]
		carro_jogador_pos(jogador1, 0, (LARGURA_PISTA / 2) - (MODELOS_VEICULOS[m1][_LARGURA] / 2))

		inteiro m2 = jogador2[_MODELO]
		carro_jogador_pos(jogador2, 400, 400 + (LARGURA_PISTA / 2) - (MODELOS_VEICULOS[m2][_LARGURA] / 2))
	}

	funcao carro_jogador_pos(inteiro arr[], inteiro offset_x, inteiro x_inicial)
	{
		inteiro modelo = arr[_MODELO]
		arr[_X] = x_inicial
		arr[_Y] = ALTURA - MODELOS_VEICULOS[modelo][_ALTURA] - 30
	}

	funcao inteiro sortear_posicao_faixa(inteiro offset_x)
	{
		inteiro largura_util = LARGURA_PISTA - (LARGURA_ACOSTAMENTO * 2)
		inteiro faixa = u.sorteia(0, 3)
		inteiro tamanho_faixa = largura_util / 4
		
		retorne offset_x + LARGURA_ACOSTAMENTO + (faixa * tamanho_faixa) + (tamanho_faixa / 2)
	}

	funcao sortear_posicao_veiculo(inteiro matriz_inimigos[][], inteiro indice, inteiro offset_x)
	{		
		inteiro indice_modelo = u.sorteia(0, u.numero_linhas(MODELOS_VEICULOS) - 1)
		inteiro altura = MODELOS_VEICULOS[indice_modelo][_ALTURA]
		
		inteiro maior_distancia = 0
		para (inteiro i = 0; i < u.numero_linhas(matriz_inimigos); i++)
		{
			se(matriz_inimigos[i][_Y] < maior_distancia)
			{
				maior_distancia = matriz_inimigos[i][_Y]
			}
		}

		inteiro y = maior_distancia - u.sorteia(MENOR_DISTANCIA_VEICULOS, MAIOR_DISTANCIA_VEICULOS)
		se(y > -(altura * 2)) y = -(altura * 2)
		
		matriz_inimigos[indice][_MODELO] = indice_modelo
		matriz_inimigos[indice][_X] = sortear_posicao_faixa(offset_x)
		matriz_inimigos[indice][_Y] = y
	}

	funcao reiniciar_estrela(inteiro matriz_estrelas[][], inteiro indice, inteiro offset_x)
	{
		matriz_estrelas[indice][_X] = sortear_posicao_faixa(offset_x)
		matriz_estrelas[indice][_Y] = -800 - u.sorteia(0, 400)
	}

	funcao reiniciar_galao(inteiro matriz_galoes[][], inteiro indice, inteiro offset_x)
	{
		matriz_galoes[indice][_X] = sortear_posicao_faixa(offset_x)
		matriz_galoes[indice][_Y] = -1500 - u.sorteia(500, 2000)
	}

	funcao limpar_tela()
	{
		g.definir_cor(g.COR_PRETO)
		g.limpar()
	}

	funcao atualizar_jogo()
	{
		atualizar_controles_velocidade()
		atualizar_estrada_jogando()
		
		se (jogador1_vivo) pontuacao_p1 = pontuacao_p1 + (velocidade_p1 / 12.0)
		se (jogador2_vivo) pontuacao_p2 = pontuacao_p2 + (velocidade_p2 / 12.0)

		atualizar_movimento_lateral()
		atualizar_inimigos()
		atualizar_estrelas()
		atualizar_galoes()
		gastar_combustivel()
		verificar_colisoes()

		se (nao jogador1_vivo e nao jogador2_vivo)
		{
			estado_jogo = ESTADO_GAME_OVER
			cooldown_tecla = 20
		}
	}

	funcao atualizar_controles_velocidade()
	{
		real max_vel_p1 = 24.0 + ((nivel_velocidade_p1 - 1) * 3.0)
		real max_vel_p2 = 24.0 + ((nivel_velocidade_p2 - 1) * 3.0)

		se (cooldown_freio > 0) cooldown_freio = cooldown_freio - 1

		// JOGADOR 1
		se (jogador1_vivo)
		{
			se (t.tecla_pressionada(t.TECLA_W)) {
				velocidade_p1 = mat.menor_numero(max_vel_p1, velocidade_p1 + 0.3)
			} senao se (t.tecla_pressionada(t.TECLA_S)) {
				velocidade_p1 = mat.maior_numero(4.0, velocidade_p1 - 0.5)
				se (cooldown_freio == 0) {
					sm.reproduzir_som(som_freio, falso)
					cooldown_freio = 30
				}
			} senao {
				se (velocidade_p1 > 12.0) velocidade_p1 = velocidade_p1 - 0.2
				se (velocidade_p1 < 12.0) velocidade_p1 = velocidade_p1 + 0.2
			}
		}

		// JOGADOR 2
		se (jogador2_vivo)
		{
			se (t.tecla_pressionada(t.TECLA_SETA_ACIMA)) {
				velocidade_p2 = mat.menor_numero(max_vel_p2, velocidade_p2 + 0.3)
			} senao se (t.tecla_pressionada(t.TECLA_SETA_ABAIXO)) {
				velocidade_p2 = mat.maior_numero(4.0, velocidade_p2 - 0.5)
				se (cooldown_freio == 0) {
					sm.reproduzir_som(som_freio, falso)
					cooldown_freio = 30
				}
			} senao {
				se (velocidade_p2 > 12.0) velocidade_p2 = velocidade_p2 - 0.2
				se (velocidade_p2 < 12.0) velocidade_p2 = velocidade_p2 + 0.2
			}
		}
	}
	
	funcao atualizar_estrada_jogando()
	{
		real vel_media = 0.0
		se (jogador1_vivo e jogador2_vivo) {
			vel_media = (velocidade_p1 + velocidade_p2) / 2.0
		} senao se (jogador1_vivo) {
			vel_media = velocidade_p1
		} senao se (jogador2_vivo) {
			vel_media = velocidade_p2
		}

		deslocamento_estrada = deslocamento_estrada + (vel_media / 2.0)
		se (deslocamento_estrada > g.altura_imagem(imagem_estrada))
		{
			deslocamento_estrada = deslocamento_estrada - g.altura_imagem(imagem_estrada)
		}
	}

	funcao atualizar_estrada_menu()
	{
		deslocamento_estrada = deslocamento_estrada + 6.0
		se (deslocamento_estrada > g.altura_imagem(imagem_estrada))
		{
			deslocamento_estrada = deslocamento_estrada - g.altura_imagem(imagem_estrada)
		}
	}

	funcao atualizar_movimento_lateral()
	{
		inteiro vel = 8

		se (jogador1_vivo)
		{
			inteiro larg1 = MODELOS_VEICULOS[jogador1[_MODELO]][_LARGURA]
			se (t.tecla_pressionada(t.TECLA_A) e jogador1[_X] > LARGURA_ACOSTAMENTO)
				jogador1[_X] = jogador1[_X] - vel
			se (t.tecla_pressionada(t.TECLA_D) e jogador1[_X] < LARGURA_PISTA - LARGURA_ACOSTAMENTO - larg1)
				jogador1[_X] = jogador1[_X] + vel
		}

		se (jogador2_vivo)
		{
			inteiro larg2 = MODELOS_VEICULOS[jogador2[_MODELO]][_LARGURA]
			se (t.tecla_pressionada(t.TECLA_SETA_ESQUERDA) e jogador2[_X] > 400 + LARGURA_ACOSTAMENTO)
				jogador2[_X] = jogador2[_X] - vel
			se (t.tecla_pressionada(t.TECLA_SETA_DIREITA) e jogador2[_X] < LARGURA - LARGURA_ACOSTAMENTO - larg2)
				jogador2[_X] = jogador2[_X] + vel
		}
	}

	funcao atualizar_inimigos()
	{
		para (inteiro i = 0; i < u.numero_linhas(inimigos_p1); i++)
		{
			inimigos_p1[i][_Y] = inimigos_p1[i][_Y] + tp.real_para_inteiro(velocidade_p1 - 4.0)
			se (inimigos_p1[i][_Y] > ALTURA) sortear_posicao_veiculo(inimigos_p1, i, 0)

			inimigos_p2[i][_Y] = inimigos_p2[i][_Y] + tp.real_para_inteiro(velocidade_p2 - 4.0)
			se (inimigos_p2[i][_Y] > ALTURA) sortear_posicao_veiculo(inimigos_p2, i, 400)
		}
	}

	funcao atualizar_estrelas()
	{
		para (inteiro i = 0; i < u.numero_linhas(estrelas_p1); i++)
		{
			estrelas_p1[i][_Y] = estrelas_p1[i][_Y] + tp.real_para_inteiro(velocidade_p1)
			se (estrelas_p1[i][_Y] > ALTURA) reiniciar_estrela(estrelas_p1, i, 0)

			estrelas_p2[i][_Y] = estrelas_p2[i][_Y] + tp.real_para_inteiro(velocidade_p2)
			se (estrelas_p2[i][_Y] > ALTURA) reiniciar_estrela(estrelas_p2, i, 400)
		}
	}

	funcao atualizar_galoes()
	{
		para (inteiro i = 0; i < u.numero_linhas(galoes_p1); i++)
		{
			galoes_p1[i][_Y] = galoes_p1[i][_Y] + tp.real_para_inteiro(velocidade_p1)
			se (galoes_p1[i][_Y] > ALTURA) reiniciar_galao(galoes_p1, i, 0)

			galoes_p2[i][_Y] = galoes_p2[i][_Y] + tp.real_para_inteiro(velocidade_p2)
			se (galoes_p2[i][_Y] > ALTURA) reiniciar_galao(galoes_p2, i, 400)
		}
	}

	funcao gastar_combustivel()
	{
		real mult_gasto_p1 = 1.0 - ((nivel_combustivel_p1 - 1) * 0.15)
		real mult_gasto_p2 = 1.0 - ((nivel_combustivel_p2 - 1) * 0.15)

		se (jogador1_vivo)
		{
			combustivel_p1 = mat.maior_numero(0.0, combustivel_p1 - ((12.0 + velocidade_p1) * mult_gasto_p1))
			se (combustivel_p1 <= (MAXIMO_COMBUSTIVEL * 0.25) e nao alarme_p1_tocado) {
				sm.reproduzir_som(som_alarme_combustivel, falso)
				alarme_p1_tocado = verdadeiro
			}
			se (combustivel_p1 <= 0.0) jogador1_vivo = falso
		}
		
		se (jogador2_vivo)
		{
			combustivel_p2 = mat.maior_numero(0.0, combustivel_p2 - ((12.0 + velocidade_p2) * mult_gasto_p2))
			se (combustivel_p2 <= (MAXIMO_COMBUSTIVEL * 0.25) e nao alarme_p2_tocado) {
				sm.reproduzir_som(som_alarme_combustivel, falso)
				alarme_p2_tocado = verdadeiro
			}
			se (combustivel_p2 <= 0.0) jogador2_vivo = falso
		}
	}

	funcao verificar_colisoes()
	{
		inteiro idx_inimigo = -1

		// P1 Bateu
		idx_inimigo = colidiu_inimigo_idx(jogador1, inimigos_p1)
		se (jogador1_vivo e idx_inimigo != -1)
		{
			sm.reproduzir_som(som_colisao, falso)
			vidas_p1 = vidas_p1 - 1
			inimigos_p1[idx_inimigo][_Y] = ALTURA + 200
			se (vidas_p1 <= 0) jogador1_vivo = falso
		}

		// P2 Bateu
		idx_inimigo = colidiu_inimigo_idx(jogador2, inimigos_p2)
		se (jogador2_vivo e idx_inimigo != -1)
		{
			sm.reproduzir_som(som_colisao, falso)
			vidas_p2 = vidas_p2 - 1
			inimigos_p2[idx_inimigo][_Y] = ALTURA + 200
			se (vidas_p2 <= 0) jogador2_vivo = falso
		}

		inteiro idx = -1
		
		// Coleta Estrelas P1
		se (jogador1_vivo e pegou_objeto(jogador1, estrelas_p1, idx, 30, 30))
		{
			sm.reproduzir_som(som_reparo, falso)
			inteiro ganho = 1
			se (mult_estrelas_p1) ganho = 2
			estrelas_p1_qtd = estrelas_p1_qtd + ganho
			banco_estrelas_p1 = banco_estrelas_p1 + ganho
			reiniciar_estrela(estrelas_p1, idx, 0)
		}
		
		// Coleta Estrelas P2
		se (jogador2_vivo e pegou_objeto(jogador2, estrelas_p2, idx, 30, 30))
		{
			sm.reproduzir_som(som_reparo, falso)
			inteiro ganho = 1
			se (mult_estrelas_p2) ganho = 2
			estrelas_p2_qtd = estrelas_p2_qtd + ganho
			banco_estrelas_p2 = banco_estrelas_p2 + ganho
			reiniciar_estrela(estrelas_p2, idx, 400)
		}

		// Galões de Combustível P1
		se (jogador1_vivo e pegou_objeto(jogador1, galoes_p1, idx, _OBJ_GALAO_LARGURA, _OBJ_GALAO_ALTURA))
		{
			sm.reproduzir_som(som_combustivel, falso)
			combustivel_p1 = mat.menor_numero(MAXIMO_COMBUSTIVEL, combustivel_p1 + COMBUSTIVEL_GALAO)
			se (combustivel_p1 > MAXIMO_COMBUSTIVEL * 0.25) alarme_p1_tocado = falso
			reiniciar_galao(galoes_p1, idx, 0)
		}

		// Galões de Combustível P2
		se (jogador2_vivo e pegou_objeto(jogador2, galoes_p2, idx, _OBJ_GALAO_LARGURA, _OBJ_GALAO_ALTURA))
		{
			sm.reproduzir_som(som_combustivel, falso)
			combustivel_p2 = mat.menor_numero(MAXIMO_COMBUSTIVEL, combustivel_p2 + COMBUSTIVEL_GALAO)
			se (combustivel_p2 > MAXIMO_COMBUSTIVEL * 0.25) alarme_p2_tocado = falso
			reiniciar_galao(galoes_p2, idx, 400)
		}
	}

	funcao inteiro colidiu_inimigo_idx(inteiro jogador[], inteiro matriz_inimigos[][])
	{
		inteiro m_jog = jogador[_MODELO]
		inteiro x1 = jogador[_X], y1 = jogador[_Y]
		inteiro w1 = MODELOS_VEICULOS[m_jog][_LARGURA], h1 = MODELOS_VEICULOS[m_jog][_ALTURA]

		para (inteiro i = 0; i < u.numero_linhas(matriz_inimigos); i++)
		{
			inteiro m_ini = matriz_inimigos[i][_MODELO]
			inteiro w2 = MODELOS_VEICULOS[m_ini][_LARGURA]
			inteiro h2 = MODELOS_VEICULOS[m_ini][_ALTURA]
			inteiro x2 = matriz_inimigos[i][_X] - (w2 / 2)
			inteiro y2 = matriz_inimigos[i][_Y]

			se (x1 < x2 + w2 e x1 + w1 > x2 e y1 < y2 + h2 e y1 + h1 > y2) retorne i
		}
		retorne -1
	}

	funcao logico pegou_objeto(inteiro jogador[], inteiro matriz_objetos[][], inteiro &indice, inteiro w2, inteiro h2)
	{
		inteiro m_jog = jogador[_MODELO]
		inteiro x1 = jogador[_X], y1 = jogador[_Y]
		inteiro w1 = MODELOS_VEICULOS[m_jog][_LARGURA], h1 = MODELOS_VEICULOS[m_jog][_ALTURA]

		para (inteiro i = 0; i < u.numero_linhas(matriz_objetos); i++)
		{
			inteiro x2 = matriz_objetos[i][_X] - (w2 / 2)
			inteiro y2 = matriz_objetos[i][_Y] - (h2 / 2)

			se (x1 < x2 + w2 e x1 + w1 > x2 e y1 < y2 + h2 e y1 + h1 > y2)
			{
				indice = i
				retorne verdadeiro
			}
		}
		retorne falso
	}

	funcao desenhar_jogo()
	{
		desenhar_cenario()
		desenhar_estrelas()
		desenhar_galoes()
		desenhar_inimigos()
		desenhar_jogadores()
		desenhar_divisoria()
		desenhar_hud()
	}

	funcao desenhar_cenario()
	{
		inteiro iy1 = tp.real_para_inteiro(mat.arredondar(deslocamento_estrada, 0))
		inteiro iy2 = tp.real_para_inteiro(mat.arredondar(deslocamento_estrada + g.altura_imagem(imagem_estrada), 0))
		inteiro iy3 = tp.real_para_inteiro(mat.arredondar(deslocamento_estrada - g.altura_imagem(imagem_estrada), 0))		
		
		g.desenhar_imagem(0, iy1, imagem_estrada)
		g.desenhar_imagem(0, iy2, imagem_estrada)
		g.desenhar_imagem(0, iy3, imagem_estrada)

		g.desenhar_imagem(400, iy1, imagem_estrada)
		g.desenhar_imagem(400, iy2, imagem_estrada)
		g.desenhar_imagem(400, iy3, imagem_estrada)
	}

	funcao desenhar_divisoria()
	{
		g.definir_cor(g.COR_PRETO)
		g.desenhar_retangulo(396, 0, 8, ALTURA, falso, verdadeiro)
	}

	funcao desenhar_estrelas()
	{
		inteiro offset_w = g.largura_imagem(imagem_estrela) / 2
		inteiro offset_h = g.altura_imagem(imagem_estrela) / 2
		
		para (inteiro i = 0; i < u.numero_linhas(estrelas_p1); i++)
		{
			g.desenhar_imagem(estrelas_p1[i][_X] - offset_w, estrelas_p1[i][_Y] - offset_h, imagem_estrela)
			g.desenhar_imagem(estrelas_p2[i][_X] - offset_w, estrelas_p2[i][_Y] - offset_h, imagem_estrela)
		}
	}

	funcao desenhar_galoes()
	{
		para (inteiro i = 0; i < u.numero_linhas(galoes_p1); i++)
		{
			g.desenhar_porcao_imagem(galoes_p1[i][_X] - (_OBJ_GALAO_LARGURA / 2), galoes_p1[i][_Y], _OBJ_GALAO_SX, _OBJ_GALAO_SY, _OBJ_GALAO_LARGURA, _OBJ_GALAO_ALTURA, imagem_objetos)
			g.desenhar_porcao_imagem(galoes_p2[i][_X] - (_OBJ_GALAO_LARGURA / 2), galoes_p2[i][_Y], _OBJ_GALAO_SX, _OBJ_GALAO_SY, _OBJ_GALAO_LARGURA, _OBJ_GALAO_ALTURA, imagem_objetos)
		}
	}

	funcao desenhar_inimigos()
	{
		desenhar_matriz_inimigos(inimigos_p1)
		desenhar_matriz_inimigos(inimigos_p2)
	}

	funcao desenhar_matriz_inimigos(inteiro matriz[][])
	{
		para (inteiro i = 0; i < u.numero_linhas(matriz); i++)
		{
			inteiro m_ini = matriz[i][_MODELO]
			inteiro sx = MODELOS_VEICULOS[m_ini][_SX]
			inteiro sy = MODELOS_VEICULOS[m_ini][_SY]
			inteiro w = MODELOS_VEICULOS[m_ini][_LARGURA]
			inteiro h = MODELOS_VEICULOS[m_ini][_ALTURA]
			
			g.desenhar_porcao_imagem(matriz[i][_X] - (w / 2), matriz[i][_Y], sx, sy, w, h, imagem_veiculos)
		}
	}

	funcao desenhar_jogadores()
	{
		se (jogador1_vivo) desenhar_carro(jogador1)
		se (jogador2_vivo) desenhar_carro(jogador2)
	}

	funcao desenhar_carro(inteiro car[])
	{
		inteiro m_car = car[_MODELO]
		g.desenhar_porcao_imagem(car[_X], car[_Y], MODELOS_VEICULOS[m_car][_SX], MODELOS_VEICULOS[m_car][_SY], MODELOS_VEICULOS[m_car][_LARGURA], MODELOS_VEICULOS[m_car][_ALTURA], imagem_veiculos)
	}

	funcao desenhar_texto_com_sombra(inteiro x, inteiro y, cadeia texto, inteiro cor, real tamanho, logico sombra)
	{
		g.definir_tamanho_texto(tamanho)
		se (sombra)
		{
			g.definir_cor(g.COR_PRETO)
			g.desenhar_texto(x + 2, y + 2, texto)
		}
		g.definir_cor(cor)
		g.desenhar_texto(x, y, texto)
	}

	funcao desenhar_texto_centralizado(inteiro y, cadeia texto, inteiro cor, real tamanho, logico sombra)
	{
		g.definir_tamanho_texto(tamanho)
		inteiro largura_txt = g.largura_texto(texto)
		inteiro x = (LARGURA / 2) - (largura_txt / 2)
		desenhar_texto_com_sombra(x, y, texto, cor, tamanho, sombra)
	}

	funcao desenhar_hud()
	{
		// HUD P1
		desenhar_texto_com_sombra(15, 15, "P1: " + tp.real_para_inteiro(pontuacao_p1) + "m | Estrelas: " + estrelas_p1_qtd, g.COR_AMARELO, 16.0, verdadeiro)
		se(jogador1_vivo) desenhar_texto_com_sombra(15, 35, "Vidas: " + vidas_p1, g.COR_VERMELHO, 16.0, verdadeiro)
		
		// HUD P2
		desenhar_texto_com_sombra(415, 15, "P2: " + tp.real_para_inteiro(pontuacao_p2) + "m | Estrelas: " + estrelas_p2_qtd, g.COR_AMARELO, 16.0, verdadeiro)
		se(jogador2_vivo) desenhar_texto_com_sombra(415, 35, "Vidas: " + vidas_p2, g.COR_VERMELHO, 16.0, verdadeiro)

		se (jogador1_vivo) desenhar_medidor_combustivel(15, 65, combustivel_p1)
		se (jogador2_vivo) desenhar_medidor_combustivel(415, 65, combustivel_p2)

		se (jogador1_vivo) desenhar_medidor_velocidade(15, 80, velocidade_p1)
		se (jogador2_vivo) desenhar_medidor_velocidade(415, 80, velocidade_p2)
	}

	funcao desenhar_medidor_combustivel(inteiro x, inteiro y, real valor_combustivel)
	{
		real porcentagem = valor_combustivel / MAXIMO_COMBUSTIVEL
		inteiro cor_barra = g.COR_BRANCO

		se (porcentagem > 0.50) cor_barra = g.COR_VERDE
		senao se (porcentagem > 0.25) cor_barra = g.COR_AMARELO
		senao cor_barra = g.COR_VERMELHO

		g.definir_tamanho_texto(12.0)
		g.definir_cor(g.COR_BRANCO)
		g.desenhar_texto(x, y - 15, "Combustível")

		g.definir_cor(cor_barra)
		g.desenhar_retangulo(x, y, tp.real_para_inteiro(LARGURA_MEDIDOR * porcentagem), ALTURA_MEDIDOR, falso, verdadeiro)

		g.definir_cor(g.COR_PRETO)
		g.desenhar_retangulo(x, y, LARGURA_MEDIDOR, ALTURA_MEDIDOR, falso, falso)
		g.definir_cor(g.COR_BRANCO)
		g.desenhar_retangulo(x - 1, y - 1, LARGURA_MEDIDOR + 2, ALTURA_MEDIDOR + 2, falso, falso)
	}

	funcao desenhar_medidor_velocidade(inteiro x, inteiro y, real vel)
	{
		inteiro vel_exibida = tp.real_para_inteiro(vel * 8) 
		
		g.definir_cor(g.COR_BRANCO)
		g.definir_tamanho_texto(14.0)
		
		se (vel > 13.0) g.definir_cor(g.COR_VERMELHO) 
		senao se (vel < 11.0) g.definir_cor(g.COR_AZUL) 
		senao g.definir_cor(g.COR_VERDE) 
		
		g.desenhar_texto(x, y, "Velocidade: " + vel_exibida + " km/h")
	}

	funcao desenhar_menu()
	{
		g.desenhar_imagem(0, 0, imagem_fundo_menu)

		g.definir_cor(g.COR_PRETO)
		g.definir_opacidade(120) 
		g.desenhar_retangulo(0, 0, LARGURA, ALTURA, falso, verdadeiro)
		g.definir_opacidade(255)

		inteiro largura_logo = g.largura_imagem(imagem_logo)
		inteiro x_logo = (LARGURA / 2) - (largura_logo / 2)
		g.desenhar_imagem(x_logo, 30, imagem_logo) 

		inteiro cor_op1 = g.COR_BRANCO, cor_op2 = g.COR_BRANCO, cor_op3 = g.COR_BRANCO
		se (opcao_menu == 0) cor_op1 = g.COR_VERDE
		se (opcao_menu == 1) cor_op2 = g.COR_VERDE
		se (opcao_menu == 2) cor_op3 = g.COR_VERDE
		
		desenhar_texto_centralizado(320, "1. JOGAR", cor_op1, 30.0, verdadeiro)
		desenhar_texto_centralizado(370, "2. SKINS", cor_op2, 30.0, verdadeiro)
		desenhar_texto_centralizado(420, "3. MELHORIAS", cor_op3, 30.0, verdadeiro)

		desenhar_texto_centralizado(540, "P1: W/S/A/D  |  P2: Setas  |  ENTER para Selecionar", g.COR_AMARELO, 16.0, falso)
	}

	funcao processar_entrada_menu()
	{
		se (cooldown_tecla > 0) 
		{
			cooldown_tecla = cooldown_tecla - 1
		}
		senao
		{
			se (t.tecla_pressionada(t.TECLA_ESC))
			{
				parar_todas_musicas()
				retorne
			}
			
			se (t.tecla_pressionada(t.TECLA_W) ou t.tecla_pressionada(t.TECLA_SETA_ACIMA))
			{
				opcao_menu = opcao_menu - 1
				se (opcao_menu < 0) opcao_menu = 2
				cooldown_tecla = 12
			}
			se (t.tecla_pressionada(t.TECLA_S) ou t.tecla_pressionada(t.TECLA_SETA_ABAIXO))
			{
				opcao_menu = opcao_menu + 1
				se (opcao_menu > 2) opcao_menu = 0
				cooldown_tecla = 12
			}
			se (t.tecla_pressionada(t.TECLA_ENTER))
			{
				cooldown_tecla = 20
				se (opcao_menu == 0)
				{
					sm.reproduzir_som(som_largada, falso)
					inicializar_elementos()
					estado_jogo = ESTADO_JOGANDO
				}
				senao se (opcao_menu == 1)
				{
					visualizando_skin_p1 = jogador1[_MODELO]
					visualizando_skin_p2 = jogador2[_MODELO]
					estado_jogo = ESTADO_SKINS
				}
				senao 
				{
					estado_jogo = ESTADO_MELHORIAS
				}
			}
		}
	}

	funcao desenhar_skins()
	{
		g.definir_cor(g.COR_PRETO)
		g.definir_opacidade(220)
		g.desenhar_retangulo(0, 0, LARGURA, ALTURA, falso, verdadeiro)
		g.definir_opacidade(255)

		desenhar_divisoria()

		g.definir_cor(g.COR_AMARELO)
		desenhar_texto_centralizado(40, "LOJA DE SKINS", g.COR_AMARELO, 35.0, verdadeiro)

		// JOGADOR 1
		g.definir_cor(g.COR_BRANCO)
		g.definir_tamanho_texto(18.0)
		g.desenhar_texto(90, 120, "Jogador 1 (A / D)")
		g.definir_cor(g.COR_AMARELO)
		g.desenhar_texto(80, 150, "Banco: " + banco_estrelas_p1 + " Estrelas")
		
		inteiro m1 = visualizando_skin_p1
		inteiro w1 = MODELOS_VEICULOS[m1][_LARGURA]
		inteiro h1 = MODELOS_VEICULOS[m1][_ALTURA]
		g.desenhar_porcao_imagem(200 - (w1 / 2), 320 - (h1 / 2), MODELOS_VEICULOS[m1][_SX], MODELOS_VEICULOS[m1][_SY], w1, h1, imagem_veiculos)

		g.definir_tamanho_texto(16.0)
		se (jogador1[_MODELO] == m1)
		{
			g.definir_cor(g.COR_VERDE)
			g.desenhar_texto(150, 420, "EQUIPADA")
		}
		senao se (skins_desbloqueadas_p1[m1])
		{
			g.definir_cor(g.COR_BRANCO)
			g.desenhar_texto(110, 420, "Pressione [W] para Equipar")
		}
		senao
		{
			g.definir_cor(g.COR_VERMELHO)
			g.desenhar_texto(100, 400, "BLOQUEADA (Custo: " + PRECO_SKIN + ")")
			se (banco_estrelas_p1 >= PRECO_SKIN)
			{
				g.definir_cor(g.COR_VERDE)
				g.desenhar_texto(110, 430, "Pressione [W] para Comprar")
			}
			senao
			{
				g.definir_cor(g.criar_cor(128, 128, 128))
				g.desenhar_texto(120, 430, "Estrelas Insuficientes")
			}
		}

		// JOGADOR 2
		g.definir_cor(g.COR_BRANCO)
		g.definir_tamanho_texto(18.0)
		g.desenhar_texto(490, 120, "Jogador 2 (Esq / Dir)")
		g.definir_cor(g.COR_AMARELO)
		g.desenhar_texto(480, 150, "Banco: " + banco_estrelas_p2 + " Estrelas")
		
		inteiro m2 = visualizando_skin_p2
		inteiro w2 = MODELOS_VEICULOS[m2][_LARGURA]
		inteiro h2 = MODELOS_VEICULOS[m2][_ALTURA]
		g.desenhar_porcao_imagem(600 - (w2 / 2), 320 - (h2 / 2), MODELOS_VEICULOS[m2][_SX], MODELOS_VEICULOS[m2][_SY], w2, h2, imagem_veiculos)

		g.definir_tamanho_texto(16.0)
		se (jogador2[_MODELO] == m2)
		{
			g.definir_cor(g.COR_VERDE)
			g.desenhar_texto(550, 420, "EQUIPADA")
		}
		senao se (skins_desbloqueadas_p2[m2])
		{
			g.definir_cor(g.COR_BRANCO)
			g.desenhar_texto(490, 420, "Pressione [CIMA] para Equipar")
		}
		senao
		{
			g.definir_cor(g.COR_VERMELHO)
			g.desenhar_texto(500, 400, "BLOQUEADA (Custo: " + PRECO_SKIN + ")")
			se (banco_estrelas_p2 >= PRECO_SKIN)
			{
				g.definir_cor(g.COR_VERDE)
				g.desenhar_texto(490, 430, "Pressione [CIMA] para Comprar")
			}
			senao
			{
				g.definir_cor(g.criar_cor(128, 128, 128))
				g.desenhar_texto(510, 430, "Estrelas Insuficientes")
			}
		}

		desenhar_texto_centralizado(520, "Pressione ENTER para Voltar", g.COR_VERDE, 20.0, verdadeiro)
	}

	funcao processar_entrada_skins()
	{
		se (cooldown_tecla > 0)
		{
			cooldown_tecla = cooldown_tecla - 1
		}
		senao
		{
			inteiro total_modelos_jogaveis = 23

			se (t.tecla_pressionada(t.TECLA_A))
			{
				visualizando_skin_p1 = visualizando_skin_p1 - 1
				se (visualizando_skin_p1 < 0) visualizando_skin_p1 = total_modelos_jogaveis
				cooldown_tecla = 12
			}
			se (t.tecla_pressionada(t.TECLA_D))
			{
				visualizando_skin_p1 = visualizando_skin_p1 + 1
				se (visualizando_skin_p1 > total_modelos_jogaveis) visualizando_skin_p1 = 0
				cooldown_tecla = 12
			}
			se (t.tecla_pressionada(t.TECLA_W))
			{
				se (skins_desbloqueadas_p1[visualizando_skin_p1]) 
				{
					jogador1[_MODELO] = visualizando_skin_p1 
					sm.reproduzir_som(som_reparo, falso)
				}
				senao se (banco_estrelas_p1 >= PRECO_SKIN) 
				{
					banco_estrelas_p1 = banco_estrelas_p1 - PRECO_SKIN
					skins_desbloqueadas_p1[visualizando_skin_p1] = verdadeiro
					jogador1[_MODELO] = visualizando_skin_p1 
					sm.reproduzir_som(som_reparo, falso)
				}
				cooldown_tecla = 15
			}

			se (t.tecla_pressionada(t.TECLA_SETA_ESQUERDA))
			{
				visualizando_skin_p2 = visualizando_skin_p2 - 1
				se (visualizando_skin_p2 < 0) visualizando_skin_p2 = total_modelos_jogaveis
				cooldown_tecla = 12
			}
			se (t.tecla_pressionada(t.TECLA_SETA_DIREITA))
			{
				visualizando_skin_p2 = visualizando_skin_p2 + 1
				se (visualizando_skin_p2 > total_modelos_jogaveis) visualizando_skin_p2 = 0
				cooldown_tecla = 12
			}
			se (t.tecla_pressionada(t.TECLA_SETA_ACIMA))
			{
				se (skins_desbloqueadas_p2[visualizando_skin_p2]) 
				{
					jogador2[_MODELO] = visualizando_skin_p2 
					sm.reproduzir_som(som_reparo, falso)
				}
				senao se (banco_estrelas_p2 >= PRECO_SKIN) 
				{
					banco_estrelas_p2 = banco_estrelas_p2 - PRECO_SKIN
					skins_desbloqueadas_p2[visualizando_skin_p2] = verdadeiro
					jogador2[_MODELO] = visualizando_skin_p2 
					sm.reproduzir_som(som_reparo, falso)
				}
				cooldown_tecla = 15
			}

			se (t.tecla_pressionada(t.TECLA_ENTER))
			{
				estado_jogo = ESTADO_MENU
				cooldown_tecla = 20
			}
		}
	}

	funcao desenhar_melhorias()
	{
		g.definir_cor(g.COR_PRETO)
		g.definir_opacidade(230)
		g.desenhar_retangulo(0, 0, LARGURA, ALTURA, falso, verdadeiro)
		g.definir_opacidade(255)

		desenhar_divisoria()
		desenhar_texto_centralizado(40, "MELHORIAS (UPGRADES)", g.COR_AMARELO, 35.0, verdadeiro)

		// ====== DADOS JOGADOR 1 ======
		g.definir_tamanho_texto(18.0)
		g.definir_cor(g.COR_BRANCO)
		g.desenhar_texto(30, 110, "P1 (W/S para mover | D para Comprar)")
		g.definir_cor(g.COR_AMARELO)
		g.desenhar_texto(30, 140, "Banco: " + banco_estrelas_p1 + " Estrelas")

		desenhar_item_melhoria(30, 190, "1. Vida Extra", nivel_vida_p1, 5, opcao_melhoria_p1 == 0, banco_estrelas_p1)
		desenhar_item_melhoria(30, 260, "2. Tanque (Gasolina)", nivel_combustivel_p1, 5, opcao_melhoria_p1 == 1, banco_estrelas_p1)
		desenhar_item_melhoria(30, 330, "3. Max Velocidade", nivel_velocidade_p1, 5, opcao_melhoria_p1 == 2, banco_estrelas_p1)
		desenhar_item_melhoria_mult(30, 400, "4. 2x Estrelas", mult_estrelas_p1, opcao_melhoria_p1 == 3, banco_estrelas_p1)

		// ====== DADOS JOGADOR 2 ======
		g.definir_tamanho_texto(18.0)
		g.definir_cor(g.COR_BRANCO)
		g.desenhar_texto(430, 110, "P2 (Setas para mover | DIR para Comprar)")
		g.definir_cor(g.COR_AMARELO)
		g.desenhar_texto(430, 140, "Banco: " + banco_estrelas_p2 + " Estrelas")

		desenhar_item_melhoria(430, 190, "1. Vida Extra", nivel_vida_p2, 5, opcao_melhoria_p2 == 0, banco_estrelas_p2)
		desenhar_item_melhoria(430, 260, "2. Tanque (Gasolina)", nivel_combustivel_p2, 5, opcao_melhoria_p2 == 1, banco_estrelas_p2)
		desenhar_item_melhoria(430, 330, "3. Max Velocidade", nivel_velocidade_p2, 5, opcao_melhoria_p2 == 2, banco_estrelas_p2)
		desenhar_item_melhoria_mult(430, 400, "4. 2x Estrelas", mult_estrelas_p2, opcao_melhoria_p2 == 3, banco_estrelas_p2)

		desenhar_texto_centralizado(520, "Pressione ENTER para Voltar", g.COR_VERDE, 20.0, verdadeiro)
	}

	funcao desenhar_item_melhoria(inteiro x, inteiro y, cadeia nome, inteiro nivel_atual, inteiro nivel_maximo, logico selecionado, inteiro saldo)
	{
		se (selecionado) g.definir_cor(g.COR_VERDE)
		senao g.definir_cor(g.COR_BRANCO)
		
		g.definir_tamanho_texto(20.0)
		g.desenhar_texto(x, y, nome + " (Nvl: " + nivel_atual + "/" + nivel_maximo + ")")
		
		g.definir_tamanho_texto(16.0)
		se (nivel_atual >= nivel_maximo) {
			g.definir_cor(g.COR_AZUL)
			g.desenhar_texto(x, y + 25, "MÁXIMO ATINGIDO")
		} senao {
			inteiro custo = nivel_atual * 3
			se (saldo >= custo) g.definir_cor(g.COR_AMARELO)
			senao g.definir_cor(g.COR_VERMELHO)
			g.desenhar_texto(x, y + 25, "Custo: " + custo + " Estrelas")
		}
	}

	funcao desenhar_item_melhoria_mult(inteiro x, inteiro y, cadeia nome, logico adquirido, logico selecionado, inteiro saldo)
	{
		se (selecionado) g.definir_cor(g.COR_VERDE)
		senao g.definir_cor(g.COR_BRANCO)
		
		g.definir_tamanho_texto(20.0)
		g.desenhar_texto(x, y, nome)
		
		g.definir_tamanho_texto(16.0)
		se (adquirido) {
			g.definir_cor(g.COR_AZUL)
			g.desenhar_texto(x, y + 25, "ADQUIRIDO")
		} senao {
			inteiro custo = 15
			se (saldo >= custo) g.definir_cor(g.COR_AMARELO)
			senao g.definir_cor(g.COR_VERMELHO)
			g.desenhar_texto(x, y + 25, "Custo: " + custo + " Estrelas")
		}
	}

	funcao tentar_comprar_melhoria(inteiro jogador_num, inteiro opcao)
	{
		se (jogador_num == 1)
		{
			escolha (opcao)
			{
				caso 0: // Vida Extra
					se (nivel_vida_p1 < 5 e banco_estrelas_p1 >= nivel_vida_p1 * 3)
					{
						banco_estrelas_p1 = banco_estrelas_p1 - (nivel_vida_p1 * 3)
						nivel_vida_p1 = nivel_vida_p1 + 1
						sm.reproduzir_som(som_reparo, falso)
					}
					pare
				caso 1: // Tanque
					se (nivel_combustivel_p1 < 5 e banco_estrelas_p1 >= nivel_combustivel_p1 * 3)
					{
						banco_estrelas_p1 = banco_estrelas_p1 - (nivel_combustivel_p1 * 3)
						nivel_combustivel_p1 = nivel_combustivel_p1 + 1
						sm.reproduzir_som(som_reparo, falso)
					}
					pare
				caso 2: // Velocidade
					se (nivel_velocidade_p1 < 5 e banco_estrelas_p1 >= nivel_velocidade_p1 * 3)
					{
						banco_estrelas_p1 = banco_estrelas_p1 - (nivel_velocidade_p1 * 3)
						nivel_velocidade_p1 = nivel_velocidade_p1 + 1
						sm.reproduzir_som(som_reparo, falso)
					}
					pare
				caso 3: // 2x Estrelas
					se (nao mult_estrelas_p1 e banco_estrelas_p1 >= 15)
					{
						banco_estrelas_p1 = banco_estrelas_p1 - 15
						mult_estrelas_p1 = verdadeiro
						sm.reproduzir_som(som_reparo, falso)
					}
					pare
			}
		}
		senao se (jogador_num == 2)
		{
			escolha (opcao)
			{
				caso 0: // Vida Extra
					se (nivel_vida_p2 < 5 e banco_estrelas_p2 >= nivel_vida_p2 * 3)
					{
						banco_estrelas_p2 = banco_estrelas_p2 - (nivel_vida_p2 * 3)
						nivel_vida_p2 = nivel_vida_p2 + 1
						sm.reproduzir_som(som_reparo, falso)
					}
					pare
				caso 1: // Tanque
					se (nivel_combustivel_p2 < 5 e banco_estrelas_p2 >= nivel_combustivel_p2 * 3)
					{
						banco_estrelas_p2 = banco_estrelas_p2 - (nivel_combustivel_p2 * 3)
						nivel_combustivel_p2 = nivel_combustivel_p2 + 1
						sm.reproduzir_som(som_reparo, falso)
					}
					pare
				caso 2: // Velocidade
					se (nivel_velocidade_p2 < 5 e banco_estrelas_p2 >= nivel_velocidade_p2 * 3)
					{
						banco_estrelas_p2 = banco_estrelas_p2 - (nivel_velocidade_p2 * 3)
						nivel_velocidade_p2 = nivel_velocidade_p2 + 1
						sm.reproduzir_som(som_reparo, falso)
					}
					pare
				caso 3: // 2x Estrelas
					se (nao mult_estrelas_p2 e banco_estrelas_p2 >= 15)
					{
						banco_estrelas_p2 = banco_estrelas_p2 - 15
						mult_estrelas_p2 = verdadeiro
						sm.reproduzir_som(som_reparo, falso)
					}
					pare
			}
		}
	}

	funcao processar_entrada_melhorias()
	{
		se (cooldown_tecla > 0)
		{
			cooldown_tecla = cooldown_tecla - 1
		}
		senao
		{
			// CONTROLES P1
			se (t.tecla_pressionada(t.TECLA_W)) {
				opcao_melhoria_p1 = opcao_melhoria_p1 - 1
				se (opcao_melhoria_p1 < 0) opcao_melhoria_p1 = 3
				cooldown_tecla = 12
			}
			se (t.tecla_pressionada(t.TECLA_S)) {
				opcao_melhoria_p1 = opcao_melhoria_p1 + 1
				se (opcao_melhoria_p1 > 3) opcao_melhoria_p1 = 0
				cooldown_tecla = 12
			}
			se (t.tecla_pressionada(t.TECLA_D)) {
				tentar_comprar_melhoria(1, opcao_melhoria_p1)
				cooldown_tecla = 15
			}

			// CONTROLES P2
			se (t.tecla_pressionada(t.TECLA_SETA_ACIMA)) {
				opcao_melhoria_p2 = opcao_melhoria_p2 - 1
				se (opcao_melhoria_p2 < 0) opcao_melhoria_p2 = 3
				cooldown_tecla = 12
			}
			se (t.tecla_pressionada(t.TECLA_SETA_ABAIXO)) {
				opcao_melhoria_p2 = opcao_melhoria_p2 + 1
				se (opcao_melhoria_p2 > 3) opcao_melhoria_p2 = 0
				cooldown_tecla = 12
			}
			se (t.tecla_pressionada(t.TECLA_SETA_DIREITA)) {
				tentar_comprar_melhoria(2, opcao_melhoria_p2)
				cooldown_tecla = 15
			}

			se (t.tecla_pressionada(t.TECLA_ENTER))
			{
				estado_jogo = ESTADO_MENU
				cooldown_tecla = 20
			}
		}
	}

	funcao desenhar_game_over()
	{
		g.definir_cor(g.COR_PRETO)
		g.definir_opacidade(200)
		g.desenhar_retangulo(0, 0, LARGURA, ALTURA, falso, verdadeiro)
		g.definir_opacidade(255)

		desenhar_texto_centralizado(200, "GAME OVER", g.COR_VERMELHO, 40.0, verdadeiro)

		cadeia resultado = ""
		se (pontuacao_p1 > pontuacao_p2) {
			resultado = "Jogador 1 Venceu!"
		} senao se (pontuacao_p2 > pontuacao_p1) {
			resultado = "Jogador 2 Venceu!"
		} senao {
			resultado = "Empate!"
		}

		desenhar_texto_centralizado(280, resultado, g.COR_AMARELO, 24.0, verdadeiro)
		desenhar_texto_centralizado(350, "P1: " + tp.real_para_inteiro(pontuacao_p1) + "m | P2: " + tp.real_para_inteiro(pontuacao_p2) + "m", g.COR_BRANCO, 18.0, verdadeiro)
		desenhar_texto_centralizado(450, "Pressione ENTER para Voltar ao Menu", g.COR_VERDE, 18.0, verdadeiro)
	}

	funcao processar_entrada_game_over()
	{
		se (cooldown_tecla > 0)
		{
			cooldown_tecla = cooldown_tecla - 1
		}
		senao
		{
			se (t.tecla_pressionada(t.TECLA_ENTER) ou t.tecla_pressionada(t.TECLA_ESC))
			{
				estado_jogo = ESTADO_MENU
				cooldown_tecla = 20
			}
		}
	}
}
/* $$$ Portugol Studio $$$ 
 * 
 * Esta seção do arquivo guarda informações do Portugol Studio.
 * Você pode apagá-la se estiver utilizando outro editor.
 * 
 * @POSICAO-CURSOR = 86099; 
 * @PONTOS-DE-PARADA = ;
 * @SIMBOLOS-INSPECIONADOS = ;
 * @FILTRO-ARVORE-TIPOS-DE-DADO = inteiro, real, logico, cadeia, caracter, vazio;
 * @FILTRO-ARVORE-TIPOS-DE-SIMBOLO = variavel, vetor, matriz, funcao;
 */