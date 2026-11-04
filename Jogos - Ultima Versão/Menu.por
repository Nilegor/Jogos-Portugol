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
						g.definir_dimensoes_janela(785, 900)
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
	
	// =============================================================
	// MODO CORRIDA 3D (pseudo-3D desenhado em 2D)  -  NOVO
	// -------------------------------------------------------------
	// Técnica: cada linha de 5 px da tela corresponde a uma distância
	// no mundo (d = DIST_K / k). A pista é desenhada linha a linha,
	// as curvas deslocam as linhas distantes e os objetos usam
	// imagens pré-escaladas (spr_*.png), escolhidas pela distância.
	// Tela dividida: P1 à esquerda (0..399), P2 à direita (400..799).
	// =============================================================

	const inteiro ESTADO_3D = 5

	const inteiro VISTA_W = 400
	const inteiro HORIZONTE = 250
	const inteiro FAIXA_PX = 5
	const inteiro NUM_FAIXAS = 70
	const real DIST_K = 350.0
	const real HW_BASE = 214.0
	const real RW_MUNDO = 6.0
	const inteiro K_CARRO = 62
	const real Z_CARRO = 5.65
	const real TAM_SEG = 40.0
	const real TAM_BANDA = 8.0
	const real TAM_TRACO = 4.0
	const inteiro N_SEG_PISTA = 20
	const inteiro CICLO_MS = 120000
	const real DIST_CHECKPOINT = 700.0
	const inteiro N_CARROS_COR = 8

	// Tipos de sprite (índice em img_sp / SP_CW / SP_CH)
	const inteiro T_PINHEIRO = 0
	const inteiro T_PEDRA = 1
	const inteiro T_PLACA = 2
	const inteiro T_OUTDOOR = 3
	const inteiro T_POSTE = 4
	const inteiro T_CONE = 5
	const inteiro T_ESTRELA = 6
	const inteiro T_GALAO = 7
	const inteiro T_PLATEIA = 8
	const inteiro T_ARBUSTO = 9
	const inteiro T_TENDA = 10
	const inteiro T_CARRO = 11
	const inteiro T_ARCO = 12

	// Tamanho de cada célula (um quadro de escala) dentro das folhas de sprites
	// Folhas compactas: cada quadro de escala tem largura própria (SP_FW) e posição (SP_FX); SP_CH = altura de cada linha
	inteiro SP_CH[13] = {185, 67, 146, 162, 177, 65, 100, 107, 76, 54, 177, 73, 0}
	inteiro SP_FX[][] = {
		{0, 7, 15, 24, 34, 46, 60, 77, 98, 123, 154, 193, 241, 302, 379},
		{0, 7, 14, 22, 31, 42, 55, 70, 88, 110, 137, 170, 211, 263, 328},
		{0, 6, 13, 21, 29, 39, 50, 63, 78, 96, 118, 145, 179, 221, 274},
		{0, 9, 20, 33, 48, 66, 88, 114, 147, 188, 239, 303, 384, 487, 619},
		{0, 7, 14, 22, 31, 42, 55, 70, 88, 110, 137, 170, 211, 263, 328},
		{0, 6, 12, 19, 26, 34, 43, 54, 67, 82, 100, 122, 148, 181, 222},
		{0, 7, 14, 22, 31, 41, 53, 67, 84, 104, 128, 158, 195, 242, 301},
		{0, 7, 14, 22, 31, 41, 53, 67, 84, 104, 128, 158, 195, 242, 301},
		{0, 8, 17, 28, 40, 55, 72, 93, 119, 151, 191, 241, 304, 384, 485},
		{0, 7, 14, 22, 31, 41, 53, 67, 84, 104, 128, 158, 195, 242, 301},
		{0, 9, 19, 31, 45, 61, 81, 105, 135, 172, 219, 278, 352, 446, 565},
		{0, 7, 15, 24, 35, 47, 62, 79, 100, 126, 158, 198, 248, 311, 391},
		{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
	}
	inteiro SP_FW[][] = {
		{7, 8, 9, 10, 12, 14, 17, 21, 25, 31, 39, 48, 61, 77, 98},
		{7, 7, 8, 9, 11, 13, 15, 18, 22, 27, 33, 41, 52, 65, 82},
		{6, 7, 8, 8, 10, 11, 13, 15, 18, 22, 27, 34, 42, 53, 67},
		{9, 11, 13, 15, 18, 22, 26, 33, 41, 51, 64, 81, 103, 132, 168},
		{7, 7, 8, 9, 11, 13, 15, 18, 22, 27, 33, 41, 52, 65, 82},
		{6, 6, 7, 7, 8, 9, 11, 13, 15, 18, 22, 26, 33, 41, 51},
		{7, 7, 8, 9, 10, 12, 14, 17, 20, 24, 30, 37, 47, 59, 75},
		{7, 7, 8, 9, 10, 12, 14, 17, 20, 24, 30, 37, 47, 59, 75},
		{8, 9, 11, 12, 15, 17, 21, 26, 32, 40, 50, 63, 80, 101, 129},
		{7, 7, 8, 9, 10, 12, 14, 17, 20, 24, 30, 37, 47, 59, 75},
		{9, 10, 12, 14, 16, 20, 24, 30, 37, 47, 59, 74, 94, 119, 152},
		{7, 8, 9, 11, 12, 15, 17, 21, 26, 32, 40, 50, 63, 80, 101},
		{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
	}
	inteiro img_sp[13]

	// Qual quadro de escala usar para cada linha k da tela (-1 = longe demais)
	inteiro FRAME_K[71] = {-1, -1, 0, 2, 3, 4, 5, 5, 6, 6, 7, 7, 7, 8, 8, 8, 9, 9, 9, 9, 9, 10, 10, 10, 10, 10, 10, 11, 11, 11, 11, 11, 11, 11, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14}
	real ESCALA_FR[16] = {0.03, 0.0386, 0.0496, 0.0638, 0.082, 0.1054, 0.1355, 0.1742, 0.2239, 0.2879, 0.3701, 0.4758, 0.6118, 0.7865, 1.0112, 1.3}

	// Curvatura da pista (valor - 10, em milésimos). A pista se repete a cada 20 trechos.
	inteiro CURVAS_PISTA[20] = {10, 10, 12, 14, 14, 12, 10, 7, 5, 5, 8, 10, 10, 13, 16, 13, 10, 6, 6, 10}

	// Ponteiro do velocímetro (valor + 50): 33 posições
	inteiro AGULHA_DX[33] = {19, 15, 11, 9, 7, 6, 6, 7, 9, 12, 16, 20, 26, 31, 37, 44, 50, 56, 63, 69, 74, 80, 84, 88, 91, 93, 94, 94, 93, 91, 89, 85, 81}
	inteiro AGULHA_DY[33] = {81, 76, 71, 65, 59, 52, 46, 39, 33, 27, 22, 17, 13, 10, 8, 6, 6, 6, 8, 10, 13, 17, 22, 27, 33, 39, 46, 52, 59, 65, 71, 76, 81}

	// Imagens do modo 3D
	inteiro img_ceu[24]
	const inteiro N_CEU = 11
	inteiro CEU_MAP[24] = {0, 0, 0, 0, 0, 0, 0, 1, 2, 3, 4, 5, 6, 6, 6, 6, 6, 6, 6, 6, 7, 8, 9, 10}
	inteiro img_montanhas = -1
	inteiro img_nuv_dia = -1
	inteiro img_nuv_tarde = -1
	inteiro img_nuv_noite = -1
	inteiro img_chuva = -1
	inteiro img_balao = -1
	inteiro img_ovni = -1
	inteiro img_hud_icones = -1
	inteiro img_painel_vel = -1
	inteiro img_semaforo = -1
	inteiro img_fundo_menu_3d = -1

	// Cores
	inteiro cor_grama_c = 0, cor_grama_e = 0, cor_rumb_v = 0, cor_rumb_b = 0
	inteiro cor_asf_a = 0, cor_asf_b = 0, cor_faixa = 0, cor_noite = 0
	inteiro cor_tarde = 0, cor_farol = 0, cor_poeira = 0, cor_chuva = 0
	inteiro cor_poste_arco = 0, cor_freio = 0

	// Estado da corrida (índice 0 = P1, 1 = P2)
	real pos3d[2]
	real xp3d[2]
	inteiro invul3d[2]
	inteiro shake3d[2]
	real prox_cp[2]
	inteiro cp_count[2]
	inteiro cp_banner[2]
	real mont_off[2]
	logico freando3d[2]
	real nuv_off = 0.0

	// Objetos dinâmicos de cada jogador
	real riv_z[2][5]
	real riv_x[2][5]
	real riv_v[2][5]
	inteiro riv_cor[2][5]
	real cone_z[2][4]
	real cone_x[2][4]
	real est_z[2][3]
	real est_x[2][3]
	real gal_z[2][2]
	real gal_x[2][2]
	real LANE_C[4]

	// Relógio, clima e ciclo dia/noite
	inteiro t_largada_ms = 0
	inteiro inicio_corrida_ms = 0
	inteiro tempo_corrida_ms = 0
	logico corrida_3d_ativa = falso
	inteiro frames3d = 0
	inteiro bob3d = 0
	real fase_dia = 0.0
	real w_dia = 1.0
	real w_noite = 0.0
	inteiro idx_ceu = 0
	logico chuva3d = falso
	inteiro chuva_nivel = 0

	// Lista de objetos visíveis na vista atual (ordenada do mais longe para o mais perto)
	real dl_z[90]
	real dl_x[90]
	inteiro dl_tipo[90]
	inteiro dl_var[90]
	inteiro dl_ord[90]
	inteiro dl_n = 0
	real cx3d[71]

	// Brilhos dos postes de luz (noite)
	inteiro glow_n = 0
	inteiro glow_x[8]
	inteiro glow_y[8]
	inteiro glow_r[8]


	// =============================================================
	// INTERFACE NOVA (HUD, menu, skins, melhorias, tela de derrota)
	// =============================================================
	inteiro img_ui_ic = -1
	inteiro img_ui_icg = -1
	inteiro img_trofeu = -1
	inteiro img_podio = -1
	inteiro img_go_bg = -1
	inteiro img_menu_vig = -1
	inteiro img_jogo_vig = -1
	inteiro img_xadrez = -1
	inteiro img_brilho = -1
	inteiro img_fumaca = -1

	inteiro cor_pn_fundo = 0, cor_pn_borda = 0, cor_ouro = 0, cor_ok = 0
	inteiro cor_ruim = 0, cor_texto_fraco = 0, cor_azul_p1 = 0, cor_laranja_p2 = 0
	inteiro cor_divisoria = 0

	inteiro tempo_ui = 0
	inteiro estado_anterior_ui = -1
	inteiro t_estado_ms = 0
	inteiro inicio_2d_ms = 0
	inteiro modo_ultima_corrida = 0
	inteiro vidas_ant[2]
	inteiro flash_dano[2]
	real recorde_dist = 0.0
	logico novo_recorde_p1 = falso
	logico novo_recorde_p2 = falso
	cadeia NOMES_SKINS[24]
	
	// VARIÁVEIS DE MENU E ÁUDIO
	inteiro opcao_menu = 0 
	inteiro cooldown_tecla = 0
	inteiro cooldown_freio = 0
	logico musica_menu_tocando = falso
	logico musica_jogo_tocando = falso
	inteiro canal_musica_menu_corrida = -1
	inteiro canal_musica_jogo_corrida = -1
	inteiro canal_trafego_corrida = -1
	logico banco_skins_iniciado = falso

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
		cadeia titulo = "HABILIDADES (UPGRADES)"
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

		g.definir_cor(0xCCCCCC)
		g.desenhar_texto(x_coluna1, 590, "*Rebatida Aleatória: Rebatidas param de seguir um Padrão")
		
		g.definir_cor(0xCCCCCC)
		g.desenhar_texto(x_coluna1, 620, "*Aumento de Velocidade: Aumenta a Velocidade do seu Personagem")
		
		g.definir_cor(0xCCCCCC)
		g.desenhar_texto(x_coluna1, 650, "*Confusão: Inverte o Controle do seu Oponente")
		g.definir_cor(0xCCCCCC)
		
		g.desenhar_texto(x_coluna1, 680, "*Congelamento: Diminui a Velocidade do seu Oponente")
		

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
		// As skins só são zeradas na primeira vez que o jogo é aberto; assim as compras
		// feitas com as estrelas continuam valendo se o jogador voltar ao menu e reabrir.
		se (nao banco_skins_iniciado)
		{
			inicializar_banco_skins()
			banco_skins_iniciado = verdadeiro
		}
		inicializar_jogo()

		// Estado limpo a cada abertura
		estado_jogo = ESTADO_MENU
		estado_anterior_ui = -1
		cooldown_tecla = 0
		musica_menu_tocando = falso
		musica_jogo_tocando = falso
		canal_musica_menu_corrida = -1
		canal_musica_jogo_corrida = -1
		canal_trafego_corrida = -1

		sm.reproduzir_som(som_ligar, falso)

		enquanto (verdadeiro)
		{
			se (estado_jogo == ESTADO_MENU e t.tecla_pressionada(t.TECLA_ESC)){
				parar_todas_musicas()
				liberar_recursos_corrida()
				retorne
			}

			// ESC durante a corrida 3D volta para o menu da corrida
			se (estado_jogo == ESTADO_3D e t.tecla_pressionada(t.TECLA_ESC)){
				parar_todas_musicas()
				estado_jogo = ESTADO_MENU
				enquanto (t.tecla_pressionada(t.TECLA_ESC))
				{
					u.aguarde(20)
				}
				cooldown_tecla = 20
			}
			tempo_ui = tempo_ui + 1
			se (estado_jogo != estado_anterior_ui)
			{
				estado_anterior_ui = estado_jogo
				t_estado_ms = u.tempo_decorrido()
				se (estado_jogo == ESTADO_GAME_OVER)
				{
					registrar_resultado()
				}
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

				caso ESTADO_3D:
					gerenciar_musica_jogo()
					atualizar_jogo_3d()
					desenhar_jogo_3d()
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


	// Libera tudo o que a corrida carregou. Sem isso, cada vez que o jogo fosse aberto pelo
	// menu as imagens e os sons seriam carregados de novo e os antigos ficariam presos na memória.
	funcao liberar_recursos_corrida()
	{
		liberar_imagens_3d()
		liberar_imagens_ui()

		g.liberar_imagem(imagem_estrada)
		g.liberar_imagem(imagem_veiculos)
		g.liberar_imagem(imagem_estrela)
		g.liberar_imagem(imagem_objetos)
		g.liberar_imagem(imagem_logo)
		g.liberar_imagem(imagem_fundo_menu)

		sm.liberar_som(musica_jogo)
		sm.liberar_som(musica_menu)
		sm.liberar_som(som_alarme_combustivel)
		sm.liberar_som(som_colisao)
		sm.liberar_som(som_combustivel)
		sm.liberar_som(som_freio)
		sm.liberar_som(som_largada)
		sm.liberar_som(som_ligar)
		sm.liberar_som(som_reparo)
		sm.liberar_som(som_trafego)
	}

	funcao gerenciar_musica_menu()
	{
		se (nao musica_menu_tocando)
		{
			parar_todas_musicas()
			canal_musica_menu_corrida = sm.reproduzir_som(musica_menu, verdadeiro)
			musica_menu_tocando = verdadeiro
		}
	}

	funcao gerenciar_musica_jogo()
	{
		se (nao musica_jogo_tocando)
		{
			parar_todas_musicas()
			canal_musica_jogo_corrida = sm.reproduzir_som(musica_jogo, verdadeiro)
			canal_trafego_corrida = sm.reproduzir_som(som_trafego, verdadeiro)
			musica_jogo_tocando = verdadeiro
		}
	}

	funcao parar_todas_musicas()
	{
		se (musica_menu_tocando)
		{
			sm.interromper_som(canal_musica_menu_corrida)
			canal_musica_menu_corrida = -1
			musica_menu_tocando = falso
		}
		se (musica_jogo_tocando)
		{
			sm.interromper_som(canal_musica_jogo_corrida)
			sm.interromper_som(canal_trafego_corrida)
			canal_musica_jogo_corrida = -1
			canal_trafego_corrida = -1
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
		carregar_imagens_3d()
		carregar_imagens_ui()
		carregar_sons()
		inicializar_elementos()
	}

	funcao carregar_imagens()
	{
		imagem_estrada = g.carregar_imagem("corrida/imagens/estrada_nova.jpg") 
		imagem_veiculos = g.carregar_imagem("corrida/imagens/veiculos_novo.png") 
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
		frames3d = frames3d + 1
		tempo_corrida_ms = u.tempo_decorrido() - inicio_2d_ms
		atualizar_clima_3d()

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
		desenhar_efeito_tempo_2d()
		desenhar_farois_2d()
		desenhar_linhas_velocidade()
		desenhar_estrelas()
		desenhar_galoes()
		desenhar_inimigos()
		desenhar_jogadores()
		desenhar_chuva_3d(0)
		desenhar_chuva_3d(400)
		g.desenhar_imagem(0, 0, img_jogo_vig)
		g.desenhar_imagem(400, 0, img_jogo_vig)
		desenhar_divisoria()
		desenhar_hud()
		desenhar_avisos_2d()
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
		g.definir_cor(cor_divisoria)
		g.desenhar_retangulo(396, 0, 8, ALTURA, falso, verdadeiro)
		g.definir_cor(cor_pn_borda)
		g.desenhar_retangulo(396, 0, 1, ALTURA, falso, verdadeiro)
		g.desenhar_retangulo(403, 0, 1, ALTURA, falso, verdadeiro)
		g.definir_cor(cor_ouro)
		para (inteiro y = 20; y < ALTURA; y = y + 60)
		{
			g.desenhar_elipse(398, y, 4, 4, verdadeiro)
		}
	}

	funcao desenhar_estrelas()
	{
		inteiro bal = (tempo_ui / 6) % 6
		se (bal > 3)
		{
			bal = 6 - bal
		}

		para (inteiro i = 0; i < u.numero_linhas(estrelas_p1); i++)
		{
			g.desenhar_imagem(estrelas_p1[i][_X] - 32, estrelas_p1[i][_Y] - 32, img_brilho)
			g.desenhar_porcao_imagem(estrelas_p1[i][_X] - 20, estrelas_p1[i][_Y] - 20 - bal, 160, 0, 40, 40, img_ui_icg)
			g.desenhar_imagem(estrelas_p2[i][_X] - 32, estrelas_p2[i][_Y] - 32, img_brilho)
			g.desenhar_porcao_imagem(estrelas_p2[i][_X] - 20, estrelas_p2[i][_Y] - 20 - bal, 160, 0, 40, 40, img_ui_icg)
		}
	}

	funcao desenhar_galoes()
	{
		para (inteiro i = 0; i < u.numero_linhas(galoes_p1); i++)
		{
			g.desenhar_imagem(galoes_p1[i][_X] - 32, galoes_p1[i][_Y] + _OBJ_GALAO_ALTURA / 2 - 32, img_brilho)
			g.desenhar_porcao_imagem(galoes_p1[i][_X] - (_OBJ_GALAO_LARGURA / 2), galoes_p1[i][_Y], _OBJ_GALAO_SX, _OBJ_GALAO_SY, _OBJ_GALAO_LARGURA, _OBJ_GALAO_ALTURA, imagem_objetos)
			g.desenhar_imagem(galoes_p2[i][_X] - 32, galoes_p2[i][_Y] + _OBJ_GALAO_ALTURA / 2 - 32, img_brilho)
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

			desenhar_sombra_obj(matriz[i][_X] - (w / 2), matriz[i][_Y], w, h)
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
		inteiro w = MODELOS_VEICULOS[m_car][_LARGURA]
		inteiro h = MODELOS_VEICULOS[m_car][_ALTURA]
		inteiro p = 0
		se (car[_X] >= 400)
		{
			p = 1
		}

		desenhar_sombra_obj(car[_X], car[_Y], w, h)

		// fumaça do escapamento
		para (inteiro i = 0; i < 3; i++)
		{
			inteiro desl = (tempo_ui * 3 + i * 9) % 27
			g.definir_cor(g.COR_BRANCO)
			g.definir_opacidade(110 - desl * 3)
			g.desenhar_elipse(car[_X] + w / 2 - (6 + desl / 3) / 2, car[_Y] + h - 6 + desl, 6 + desl / 3, 6 + desl / 3, verdadeiro)
		}
		g.definir_opacidade(255)

		g.desenhar_porcao_imagem(car[_X], car[_Y], MODELOS_VEICULOS[m_car][_SX], MODELOS_VEICULOS[m_car][_SY], w, h, imagem_veiculos)

		// luzes de freio
		logico freando = t.tecla_pressionada(t.TECLA_S)
		se (p == 1)
		{
			freando = t.tecla_pressionada(t.TECLA_SETA_ABAIXO)
		}
		se (freando)
		{
			g.definir_cor(cor_freio)
			g.definir_opacidade(170)
			g.desenhar_elipse(car[_X] + 3, car[_Y] + h - 8, 12, 8, verdadeiro)
			g.desenhar_elipse(car[_X] + w - 15, car[_Y] + h - 8, 12, 8, verdadeiro)
			g.definir_opacidade(255)
		}
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
		desenhar_hud_jogador(0, "P1", cor_azul_p1, pontuacao_p1, vidas_p1, estrelas_p1_qtd, combustivel_p1, velocidade_p1, jogador1_vivo)
		desenhar_hud_jogador(400, "P2", cor_laranja_p2, pontuacao_p2, vidas_p2, estrelas_p2_qtd, combustivel_p2, velocidade_p2, jogador2_vivo)
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

		g.definir_cor(cor_pn_fundo)
		g.desenhar_retangulo(x - 2, y - 2, LARGURA_MEDIDOR + 4, ALTURA_MEDIDOR + 4, verdadeiro, verdadeiro)

		inteiro w_barra = tp.real_para_inteiro(LARGURA_MEDIDOR * porcentagem)
		se (w_barra > 0)
		{
			g.definir_cor(cor_barra)
			g.desenhar_retangulo(x, y, w_barra, ALTURA_MEDIDOR, verdadeiro, verdadeiro)
			g.definir_cor(g.COR_BRANCO)
			g.definir_opacidade(70)
			g.desenhar_retangulo(x, y, w_barra, 3, falso, verdadeiro)
			g.definir_opacidade(255)
		}

		g.definir_cor(cor_pn_fundo)
		para (inteiro j = 1; j < 4; j++)
		{
			g.desenhar_retangulo(x + j * LARGURA_MEDIDOR / 4, y, 1, ALTURA_MEDIDOR, falso, verdadeiro)
		}

		g.definir_cor(cor_pn_borda)
		g.desenhar_retangulo(x - 2, y - 2, LARGURA_MEDIDOR + 4, ALTURA_MEDIDOR + 4, verdadeiro, falso)

		se (porcentagem <= 0.25 e (tempo_ui / 8) % 2 == 0)
		{
			g.definir_cor(g.COR_VERMELHO)
			g.desenhar_retangulo(x - 3, y - 3, LARGURA_MEDIDOR + 6, ALTURA_MEDIDOR + 6, verdadeiro, falso)
		}
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
				se (opcao_menu < 0) opcao_menu = 3
				cooldown_tecla = 12
			}
			se (t.tecla_pressionada(t.TECLA_S) ou t.tecla_pressionada(t.TECLA_SETA_ABAIXO))
			{
				opcao_menu = opcao_menu + 1
				se (opcao_menu > 3) opcao_menu = 0
				cooldown_tecla = 12
			}
			se (t.tecla_pressionada(t.TECLA_ENTER))
			{
				cooldown_tecla = 20
				se (opcao_menu == 0)
				{
					sm.reproduzir_som(som_largada, falso)
					inicializar_elementos()
					reiniciar_ui_corrida(0)
					estado_jogo = ESTADO_JOGANDO
				}
				senao se (opcao_menu == 1)
				{
					visualizando_skin_p1 = jogador1[_MODELO]
					visualizando_skin_p2 = jogador2[_MODELO]
					estado_jogo = ESTADO_SKINS
				}
				senao se (opcao_menu == 2)
				{
					estado_jogo = ESTADO_MELHORIAS
				}
				senao
				{
					sm.reproduzir_som(som_largada, falso)
					inicializar_3d()
					reiniciar_ui_corrida(1)
					estado_jogo = ESTADO_3D
				}
			}
		}
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

	// -------------------------------------------------------------
	// Carregamento
	// -------------------------------------------------------------
	funcao carregar_imagens_3d()
	{
		cadeia pasta = "corrida/imagens3d/"

		img_sp[T_PINHEIRO] = g.carregar_imagem(pasta + "spr_pinheiro.png")
		img_sp[T_PEDRA] = g.carregar_imagem(pasta + "spr_pedra.png")
		img_sp[T_PLACA] = g.carregar_imagem(pasta + "spr_placa.png")
		img_sp[T_OUTDOOR] = g.carregar_imagem(pasta + "spr_outdoor.png")
		img_sp[T_POSTE] = g.carregar_imagem(pasta + "spr_poste.png")
		img_sp[T_CONE] = g.carregar_imagem(pasta + "spr_cone.png")
		img_sp[T_ESTRELA] = g.carregar_imagem(pasta + "spr_estrela.png")
		img_sp[T_GALAO] = g.carregar_imagem(pasta + "spr_galao.png")
		img_sp[T_PLATEIA] = g.carregar_imagem(pasta + "spr_plateia.png")
		img_sp[T_ARBUSTO] = g.carregar_imagem(pasta + "spr_arbusto.png")
		img_sp[T_TENDA] = g.carregar_imagem(pasta + "spr_tenda.png")
		img_sp[T_CARRO] = g.carregar_imagem(pasta + "spr_carros.png")

		para (inteiro i = 0; i < N_CEU; i++)
		{
			cadeia nome_ceu = pasta + "ceu_" + i + ".png"
			se (i < 10)
			{
				nome_ceu = pasta + "ceu_0" + i + ".png"
			}
			img_ceu[i] = g.carregar_imagem(nome_ceu)
		}

		img_montanhas = g.carregar_imagem(pasta + "montanhas.png")
		img_nuv_dia = g.carregar_imagem(pasta + "nuvens_dia.png")
		img_nuv_tarde = g.carregar_imagem(pasta + "nuvens_tarde.png")
		img_nuv_noite = g.carregar_imagem(pasta + "nuvens_noite.png")
		img_chuva = g.carregar_imagem(pasta + "chuva.png")
		img_balao = g.carregar_imagem(pasta + "balao.png")
		img_ovni = g.carregar_imagem(pasta + "ovni.png")
		img_hud_icones = g.carregar_imagem(pasta + "hud_icones.png")
		img_painel_vel = g.carregar_imagem(pasta + "painel_vel.png")
		img_semaforo = g.carregar_imagem(pasta + "semaforo.png")
		img_fundo_menu_3d = g.carregar_imagem(pasta + "fundo_menu_3d.png")

		cor_grama_c = g.criar_cor(62, 150, 62)
		cor_grama_e = g.criar_cor(48, 128, 52)
		cor_rumb_v = g.criar_cor(214, 40, 40)
		cor_rumb_b = g.criar_cor(240, 240, 240)
		cor_asf_a = g.criar_cor(92, 92, 98)
		cor_asf_b = g.criar_cor(86, 86, 92)
		cor_faixa = g.criar_cor(240, 240, 232)
		cor_noite = g.criar_cor(6, 10, 40)
		cor_tarde = g.criar_cor(255, 130, 40)
		cor_farol = g.criar_cor(255, 246, 200)
		cor_poeira = g.criar_cor(140, 110, 80)
		cor_chuva = g.criar_cor(60, 70, 100)
		cor_poste_arco = g.criar_cor(70, 72, 84)
		cor_freio = g.criar_cor(255, 50, 40)
	}

	funcao liberar_imagens_3d()
	{
		para (inteiro i = 0; i < 12; i++)
		{
			g.liberar_imagem(img_sp[i])
		}
		para (inteiro i = 0; i < N_CEU; i++)
		{
			g.liberar_imagem(img_ceu[i])
		}
		g.liberar_imagem(img_montanhas)
		g.liberar_imagem(img_nuv_dia)
		g.liberar_imagem(img_nuv_tarde)
		g.liberar_imagem(img_nuv_noite)
		g.liberar_imagem(img_chuva)
		g.liberar_imagem(img_balao)
		g.liberar_imagem(img_ovni)
		g.liberar_imagem(img_hud_icones)
		g.liberar_imagem(img_painel_vel)
		g.liberar_imagem(img_semaforo)
		g.liberar_imagem(img_fundo_menu_3d)
	}

	// -------------------------------------------------------------
	// Início de uma corrida 3D
	// -------------------------------------------------------------
	funcao inicializar_3d()
	{
		inicializar_elementos()   // reaproveita vidas, combustível, upgrades, pontuação...

		LANE_C[0] = -0.75
		LANE_C[1] = -0.25
		LANE_C[2] = 0.25
		LANE_C[3] = 0.75

		para (inteiro p = 0; p < 2; p++)
		{
			pos3d[p] = 0.0
			xp3d[p] = 0.0
			invul3d[p] = 0
			shake3d[p] = 0
			prox_cp[p] = DIST_CHECKPOINT
			cp_count[p] = 0
			cp_banner[p] = 0
			mont_off[p] = 0.0
			freando3d[p] = falso

			para (inteiro i = 0; i < 5; i++)
			{
				riv_z[p][i] = 40.0 + i * 45.0 + u.sorteia(0, 20)
				riv_x[p][i] = LANE_C[u.sorteia(0, 3)]
				riv_v[p][i] = 0.45 + u.sorteia(0, 35) / 100.0
				riv_cor[p][i] = u.sorteia(0, 23)
			}
			para (inteiro i = 0; i < 4; i++)
			{
				cone_z[p][i] = 80.0 + i * 70.0 + u.sorteia(0, 40)
				cone_x[p][i] = u.sorteia(-9, 9) / 10.0
			}
			para (inteiro i = 0; i < 3; i++)
			{
				est_z[p][i] = 35.0 + i * 75.0 + u.sorteia(0, 30)
				est_x[p][i] = LANE_C[u.sorteia(0, 3)]
			}
			para (inteiro i = 0; i < 2; i++)
			{
				gal_z[p][i] = 120.0 + i * 260.0 + u.sorteia(0, 60)
				gal_x[p][i] = LANE_C[u.sorteia(0, 3)]
			}
		}

		nuv_off = 0.0
		frames3d = 0
		corrida_3d_ativa = falso
		tempo_corrida_ms = 0
		fase_dia = 0.0
		w_dia = 1.0
		w_noite = 0.0
		idx_ceu = 0
		chuva3d = falso
		chuva_nivel = 0
		t_largada_ms = u.tempo_decorrido()
	}

	// -------------------------------------------------------------
	// Pista: curvatura e clima
	// -------------------------------------------------------------
	funcao real curva3d(real z)
	{
		inteiro i = tp.real_para_inteiro(z / TAM_SEG)
		se (i * TAM_SEG > z)
		{
			i = i - 1
		}
		se (i < 0)
		{
			i = 0
		}
		real frac = (z - (i * TAM_SEG)) / TAM_SEG
		inteiro va = CURVAS_PISTA[i % N_SEG_PISTA] - 10
		inteiro vb = CURVAS_PISTA[(i + 1) % N_SEG_PISTA] - 10
		retorne (va + (vb - va) * frac) / 1000.0
	}

	funcao real peso_noite(real f)
	{
		se (f < 0.40)
		{
			retorne 0.0
		}
		se (f < 0.50)
		{
			retorne (f - 0.40) / 0.10
		}
		se (f < 0.82)
		{
			retorne 1.0
		}
		se (f < 0.90)
		{
			retorne 1.0 - (f - 0.82) / 0.08
		}
		retorne 0.0
	}

	funcao real peso_dia(real f)
	{
		se (f < 0.30)
		{
			retorne 1.0
		}
		se (f < 0.40)
		{
			retorne 1.0 - (f - 0.30) / 0.10
		}
		se (f < 0.90)
		{
			retorne 0.0
		}
		retorne (f - 0.90) / 0.10
	}

	funcao atualizar_clima_3d()
	{
		fase_dia = (tempo_corrida_ms % CICLO_MS) / 120000.0
		w_noite = peso_noite(fase_dia)
		w_dia = peso_dia(fase_dia)

		idx_ceu = tp.real_para_inteiro(fase_dia * 24.0)
		se (idx_ceu > 23)
		{
			idx_ceu = 23
		}
		se (idx_ceu < 0)
		{
			idx_ceu = 0
		}

		// Chuva: aparece de 55 s a 85 s de cada ciclo de 100 s
		inteiro ms_ciclo = tempo_corrida_ms % 100000
		chuva3d = falso
		chuva_nivel = 0
		se (ms_ciclo >= 55000 e ms_ciclo < 85000)
		{
			chuva3d = verdadeiro
			inteiro n_entra = (ms_ciclo - 55000) / 40
			inteiro n_sai = (85000 - ms_ciclo) / 40
			chuva_nivel = 70
			se (n_entra < chuva_nivel)
			{
				chuva_nivel = n_entra
			}
			se (n_sai < chuva_nivel)
			{
				chuva_nivel = n_sai
			}
		}

		nuv_off = nuv_off + 0.35
		se (nuv_off >= 800.0)
		{
			nuv_off = nuv_off - 800.0
		}
	}

	// -------------------------------------------------------------
	// Atualização do jogo
	// -------------------------------------------------------------
	funcao atualizar_jogo_3d()
	{
		frames3d = frames3d + 1
		bob3d = (frames3d / 3) % 8
		se (bob3d > 4)
		{
			bob3d = 8 - bob3d
		}

		// Contagem regressiva do semáforo (2 segundos)
		se (u.tempo_decorrido() - t_largada_ms < 2000)
		{
			retorne
		}
		se (nao corrida_3d_ativa)
		{
			corrida_3d_ativa = verdadeiro
			inicio_corrida_ms = u.tempo_decorrido()
		}
		tempo_corrida_ms = u.tempo_decorrido() - inicio_corrida_ms

		atualizar_clima_3d()

		freando3d[0] = t.tecla_pressionada(t.TECLA_S)
		freando3d[1] = t.tecla_pressionada(t.TECLA_SETA_ABAIXO)

		atualizar_controles_velocidade()   // mesma aceleração/freio do modo 2D

		se (jogador1_vivo)
		{
			atualizar_jogador_3d(0)
			atualizar_dinamicos_3d(0)
		}
		se (jogador2_vivo)
		{
			atualizar_jogador_3d(1)
			atualizar_dinamicos_3d(1)
		}

		gastar_combustivel()
		verificar_colisoes_3d()

		se (nao jogador1_vivo e nao jogador2_vivo)
		{
			estado_jogo = ESTADO_GAME_OVER
			cooldown_tecla = 20
		}
	}

	funcao ajustar_velocidade_3d(inteiro p, real fator, real subtrai)
	{
		real nova = 0.0
		se (p == 0)
		{
			nova = velocidade_p1 * fator - subtrai
			se (nova < 6.0)
			{
				nova = mat.menor_numero(6.0, velocidade_p1)
			}
			velocidade_p1 = nova
		}
		senao
		{
			nova = velocidade_p2 * fator - subtrai
			se (nova < 6.0)
			{
				nova = mat.menor_numero(6.0, velocidade_p2)
			}
			velocidade_p2 = nova
		}
	}

	funcao atualizar_jogador_3d(inteiro p)
	{
		real vel = velocidade_p1
		se (p == 1)
		{
			vel = velocidade_p2
		}
		real vm = vel * 0.1   // unidades de mundo por quadro

		real direcao = 0.0
		se (p == 0)
		{
			se (t.tecla_pressionada(t.TECLA_A))
			{
				direcao = direcao - 1.0
			}
			se (t.tecla_pressionada(t.TECLA_D))
			{
				direcao = direcao + 1.0
			}
		}
		senao
		{
			se (t.tecla_pressionada(t.TECLA_SETA_ESQUERDA))
			{
				direcao = direcao - 1.0
			}
			se (t.tecla_pressionada(t.TECLA_SETA_DIREITA))
			{
				direcao = direcao + 1.0
			}
		}

		real aderencia = 1.0
		se (chuva3d)
		{
			aderencia = 0.7
		}

		real nx = xp3d[p]
		nx = nx + direcao * 0.04 * aderencia * (0.45 + vm * 0.45)
		// força centrífuga: a curva empurra o carro para fora
		nx = nx - curva3d(pos3d[p] + Z_CARRO) * 1000.0 * vm * 0.0011
		// derrapagem leve na chuva
		se (chuva3d)
		{
			nx = nx + (((frames3d / 20) % 7) - 3) * 0.0007 * vm
		}

		se (nx > 1.45)
		{
			nx = 1.45
			ajustar_velocidade_3d(p, 0.96, 0.0)
		}
		se (nx < -1.45)
		{
			nx = -1.45
			ajustar_velocidade_3d(p, 0.96, 0.0)
		}
		// fora do asfalto (acostamento e grama): perde velocidade
		se (nx > 1.04 ou nx < -1.04)
		{
			ajustar_velocidade_3d(p, 1.0, 0.35)
		}
		xp3d[p] = nx

		pos3d[p] = pos3d[p] + vm

		se (invul3d[p] > 0)
		{
			invul3d[p] = invul3d[p] - 1
		}
		se (shake3d[p] > 0)
		{
			shake3d[p] = shake3d[p] - 1
		}
		se (cp_banner[p] > 0)
		{
			cp_banner[p] = cp_banner[p] - 1
		}

		// montanhas se movem devagar ao contornar curvas (paralaxe)
		mont_off[p] = mont_off[p] + curva3d(pos3d[p] + 40.0) * 1000.0 * vm * 0.55
		se (mont_off[p] >= 800.0)
		{
			mont_off[p] = mont_off[p] - 800.0
		}
		se (mont_off[p] < 0.0)
		{
			mont_off[p] = mont_off[p] + 800.0
		}

		// pontuação em metros, igual ao modo 2D
		se (p == 0)
		{
			pontuacao_p1 = pontuacao_p1 + (velocidade_p1 / 12.0)
		}
		senao
		{
			pontuacao_p2 = pontuacao_p2 + (velocidade_p2 / 12.0)
		}

		// checkpoint: passou pelo arco => bônus de combustível
		se (pos3d[p] + Z_CARRO >= prox_cp[p])
		{
			prox_cp[p] = prox_cp[p] + DIST_CHECKPOINT
			cp_count[p] = cp_count[p] + 1
			cp_banner[p] = 120
			sm.reproduzir_som(som_combustivel, falso)
			se (p == 0)
			{
				combustivel_p1 = mat.menor_numero(MAXIMO_COMBUSTIVEL, combustivel_p1 + 3000.0)
				se (combustivel_p1 > MAXIMO_COMBUSTIVEL * 0.25)
				{
					alarme_p1_tocado = falso
				}
			}
			senao
			{
				combustivel_p2 = mat.menor_numero(MAXIMO_COMBUSTIVEL, combustivel_p2 + 3000.0)
				se (combustivel_p2 > MAXIMO_COMBUSTIVEL * 0.25)
				{
					alarme_p2_tocado = falso
				}
			}
		}
	}

	// Rivais, cones, estrelas e galões
	funcao atualizar_dinamicos_3d(inteiro p)
	{
		para (inteiro i = 0; i < 5; i++)
		{
			riv_z[p][i] = riv_z[p][i] + riv_v[p][i]
			se (riv_z[p][i] < pos3d[p] - 12.0 ou riv_z[p][i] > pos3d[p] + 330.0)
			{
				reiniciar_rival_3d(p, i)
			}
		}
		para (inteiro i = 0; i < 4; i++)
		{
			se (cone_z[p][i] < pos3d[p] - 10.0)
			{
				reiniciar_cone_3d(p, i)
			}
		}
		para (inteiro i = 0; i < 3; i++)
		{
			se (est_z[p][i] < pos3d[p] - 10.0)
			{
				reiniciar_estrela_3d(p, i)
			}
		}
		para (inteiro i = 0; i < 2; i++)
		{
			se (gal_z[p][i] < pos3d[p] - 10.0)
			{
				reiniciar_galao_3d(p, i)
			}
		}
	}

	funcao reiniciar_rival_3d(inteiro p, inteiro i)
	{
		real zmax = pos3d[p] + 90.0
		para (inteiro j = 0; j < 5; j++)
		{
			se (riv_z[p][j] > zmax)
			{
				zmax = riv_z[p][j]
			}
		}
		riv_z[p][i] = zmax + u.sorteia(25, 70)
		riv_x[p][i] = LANE_C[u.sorteia(0, 3)]
		riv_v[p][i] = 0.45 + u.sorteia(0, 35) / 100.0
		riv_cor[p][i] = u.sorteia(0, 23)
	}

	funcao reiniciar_cone_3d(inteiro p, inteiro i)
	{
		real zmax = pos3d[p] + 120.0
		para (inteiro j = 0; j < 4; j++)
		{
			se (cone_z[p][j] > zmax)
			{
				zmax = cone_z[p][j]
			}
		}
		cone_z[p][i] = zmax + u.sorteia(50, 130)
		cone_x[p][i] = u.sorteia(-9, 9) / 10.0
	}

	funcao reiniciar_estrela_3d(inteiro p, inteiro i)
	{
		real zmax = pos3d[p] + 60.0
		para (inteiro j = 0; j < 3; j++)
		{
			se (est_z[p][j] > zmax)
			{
				zmax = est_z[p][j]
			}
		}
		est_z[p][i] = zmax + u.sorteia(70, 160)
		est_x[p][i] = LANE_C[u.sorteia(0, 3)]
	}

	funcao reiniciar_galao_3d(inteiro p, inteiro i)
	{
		real zmax = pos3d[p] + 100.0
		para (inteiro j = 0; j < 2; j++)
		{
			se (gal_z[p][j] > zmax)
			{
				zmax = gal_z[p][j]
			}
		}
		gal_z[p][i] = zmax + u.sorteia(180, 380)
		gal_x[p][i] = LANE_C[u.sorteia(0, 3)]
	}

	// O objeto cruzou o plano do carro neste quadro? (dz = z_objeto - z_carro, rel = velocidade relativa)
	funcao logico cruzou_3d(real dz, real rel)
	{
		se (rel >= 0.0)
		{
			retorne dz <= 0.9 e dz >= -(rel + 0.6)
		}
		retorne dz >= -0.9 e dz <= (-rel + 0.6)
	}

	funcao bater_3d(inteiro p)
	{
		sm.reproduzir_som(som_colisao, falso)
		invul3d[p] = 80
		shake3d[p] = 24
		ajustar_velocidade_3d(p, 0.55, 0.0)
		se (p == 0)
		{
			vidas_p1 = vidas_p1 - 1
			se (vidas_p1 <= 0)
			{
				jogador1_vivo = falso
			}
		}
		senao
		{
			vidas_p2 = vidas_p2 - 1
			se (vidas_p2 <= 0)
			{
				jogador2_vivo = falso
			}
		}
	}

	funcao verificar_colisoes_3d()
	{
		para (inteiro p = 0; p < 2; p++)
		{
			logico vivo = jogador1_vivo
			real vel = velocidade_p1
			se (p == 1)
			{
				vivo = jogador2_vivo
				vel = velocidade_p2
			}

			se (vivo)
			{
				real vm = vel * 0.1
				real zc = pos3d[p] + Z_CARRO
				real xc = xp3d[p]

				// rivais
				para (inteiro i = 0; i < 5; i++)
				{
					se (invul3d[p] == 0 e mat.valor_absoluto(riv_x[p][i] - xc) < 0.30)
					{
						se (cruzou_3d(riv_z[p][i] - zc, vm - riv_v[p][i]))
						{
							bater_3d(p)
							reiniciar_rival_3d(p, i)
						}
					}
				}

				// cones: só atrapalham (perdem velocidade), não tiram vida
				para (inteiro i = 0; i < 4; i++)
				{
					se (invul3d[p] == 0 e mat.valor_absoluto(cone_x[p][i] - xc) < 0.28)
					{
						se (cruzou_3d(cone_z[p][i] - zc, vm))
						{
							sm.reproduzir_som(som_colisao, falso)
							shake3d[p] = 12
							ajustar_velocidade_3d(p, 0.65, 0.0)
							reiniciar_cone_3d(p, i)
						}
					}
				}

				// estrelas
				para (inteiro i = 0; i < 3; i++)
				{
					se (mat.valor_absoluto(est_x[p][i] - xc) < 0.34)
					{
						se (cruzou_3d(est_z[p][i] - zc, vm))
						{
							sm.reproduzir_som(som_reparo, falso)
							inteiro ganho = 1
							se (p == 0)
							{
								se (mult_estrelas_p1)
								{
									ganho = 2
								}
								estrelas_p1_qtd = estrelas_p1_qtd + ganho
								banco_estrelas_p1 = banco_estrelas_p1 + ganho
							}
							senao
							{
								se (mult_estrelas_p2)
								{
									ganho = 2
								}
								estrelas_p2_qtd = estrelas_p2_qtd + ganho
								banco_estrelas_p2 = banco_estrelas_p2 + ganho
							}
							reiniciar_estrela_3d(p, i)
						}
					}
				}

				// galões de combustível
				para (inteiro i = 0; i < 2; i++)
				{
					se (mat.valor_absoluto(gal_x[p][i] - xc) < 0.34)
					{
						se (cruzou_3d(gal_z[p][i] - zc, vm))
						{
							sm.reproduzir_som(som_combustivel, falso)
							se (p == 0)
							{
								combustivel_p1 = mat.menor_numero(MAXIMO_COMBUSTIVEL, combustivel_p1 + COMBUSTIVEL_GALAO)
								se (combustivel_p1 > MAXIMO_COMBUSTIVEL * 0.25)
								{
									alarme_p1_tocado = falso
								}
							}
							senao
							{
								combustivel_p2 = mat.menor_numero(MAXIMO_COMBUSTIVEL, combustivel_p2 + COMBUSTIVEL_GALAO)
								se (combustivel_p2 > MAXIMO_COMBUSTIVEL * 0.25)
								{
									alarme_p2_tocado = falso
								}
							}
							reiniciar_galao_3d(p, i)
						}
					}
				}
			}
		}
	}

	// -------------------------------------------------------------
	// Desenho: ferramentas com recorte na vista (evita invadir a outra metade)
	// -------------------------------------------------------------
	funcao ret_vista(inteiro xa, inteiro y, inteiro xb, inteiro h, inteiro vx0)
	{
		se (xa < vx0)
		{
			xa = vx0
		}
		se (xb > vx0 + VISTA_W)
		{
			xb = vx0 + VISTA_W
		}
		se (xb > xa)
		{
			g.desenhar_retangulo(xa, y, xb - xa, h, falso, verdadeiro)
		}
	}

	funcao porcao_vista(inteiro dx, inteiro dy, inteiro sx, inteiro sy, inteiro larg, inteiro alt, inteiro imagem, inteiro vx0)
	{
		inteiro esq = vx0
		inteiro dir = vx0 + VISTA_W
		se (dx >= dir ou dx + larg <= esq)
		{
			retorne
		}
		se (dx < esq)
		{
			inteiro corte = esq - dx
			dx = esq
			sx = sx + corte
			larg = larg - corte
		}
		se (dx + larg > dir)
		{
			larg = dir - dx
		}
		g.desenhar_porcao_imagem(dx, dy, sx, sy, larg, alt, imagem)
	}

	// Janela de 400 px sobre uma imagem que se repete na horizontal (largura 800)
	funcao faixa_loop(inteiro imagem, inteiro larg_img, inteiro alt_img, inteiro y, inteiro desloc, inteiro vx0)
	{
		inteiro o = desloc % larg_img
		se (o < 0)
		{
			o = o + larg_img
		}
		se (o + VISTA_W <= larg_img)
		{
			g.desenhar_porcao_imagem(vx0, y, o, 0, VISTA_W, alt_img, imagem)
		}
		senao
		{
			inteiro w1 = larg_img - o
			g.desenhar_porcao_imagem(vx0, y, o, 0, w1, alt_img, imagem)
			g.desenhar_porcao_imagem(vx0 + w1, y, 0, 0, VISTA_W - w1, alt_img, imagem)
		}
	}

	funcao texto_vista(inteiro vx0, inteiro y, cadeia texto, inteiro cor, real tamanho)
	{
		g.definir_tamanho_texto(tamanho)
		inteiro larg_txt = g.largura_texto(texto)
		desenhar_texto_com_sombra(vx0 + (VISTA_W / 2) - (larg_txt / 2), y, texto, cor, tamanho, verdadeiro)
	}

	// -------------------------------------------------------------
	// Desenho: cena
	// -------------------------------------------------------------
	funcao desenhar_jogo_3d()
	{
		desenhar_vista_3d(0)
		desenhar_vista_3d(1)
		desenhar_divisoria()
	}

	funcao desenhar_vista_3d(inteiro p)
	{
		inteiro vx0 = p * VISTA_W

		desenhar_ceu_3d(p, vx0)
		calcular_centros_3d(p, vx0)
		desenhar_chao_3d(p, vx0)
		montar_lista_3d(p)
		ordenar_lista_3d()
		desenhar_lista_3d(vx0)
		desenhar_noite_3d(vx0)
		desenhar_farois_3d(p, vx0)
		desenhar_carro_jogador_3d(p, vx0)
		desenhar_brilhos_3d(vx0)
		desenhar_chuva_3d(vx0)
		desenhar_hud_3d(p, vx0)
		desenhar_avisos_3d(p, vx0)
	}

	funcao desenhar_ceu_3d(inteiro p, inteiro vx0)
	{
		// Céu: 24 quadros pré-misturados (dia -> entardecer -> noite -> amanhecer)
		g.desenhar_imagem(vx0, 0, img_ceu[CEU_MAP[idx_ceu]])

		// Nuvens (cor muda com a hora)
		inteiro img_n = img_nuv_dia
		se (w_noite > 0.5)
		{
			img_n = img_nuv_noite
		}
		senao se (w_dia < 0.5)
		{
			img_n = img_nuv_tarde
		}
		faixa_loop(img_n, 800, 90, 24, tp.real_para_inteiro(nuv_off), vx0)

		// Balão de ar quente: cruza o céu de dia, a cada 50 s
		se (w_dia > 0.5)
		{
			inteiro ms_b = tempo_corrida_ms % 50000
			se (ms_b < 26000)
			{
				inteiro bx = vx0 - 80 + (ms_b * 560 / 26000)
				inteiro by = 95 - (ms_b / 1000)
				porcao_vista(bx, by, 0, 0, 80, 110, img_balao, vx0)
			}
		}

		// OVNI: aparece de noite, a cada 37 s
		se (w_noite > 0.6)
		{
			inteiro ms_u = tempo_corrida_ms % 37000
			se (ms_u < 10000)
			{
				inteiro ux = vx0 + VISTA_W - (ms_u * 500 / 10000)
				inteiro bal = 10 - ((tempo_corrida_ms / 90) % 20)
				se (bal < 0)
				{
					bal = -bal
				}
				porcao_vista(ux, 36 + bal, 0, 0, 96, 44, img_ovni, vx0)
			}
		}

		// Montanhas (paralaxe)
		faixa_loop(img_montanhas, 800, 120, HORIZONTE - 110, tp.real_para_inteiro(mont_off[p]), vx0)
	}

	// Calcula o centro (x) da pista em cada linha, somando a curvatura de longe para perto
	funcao calcular_centros_3d(inteiro p, inteiro vx0)
	{
		real cam = xp3d[p] * 0.75
		real acum_x = 0.0
		real vel_x = 0.0
		real d_ant = DIST_K / NUM_FAIXAS
		inteiro k = NUM_FAIXAS
		enquanto (k >= 1)
		{
			real dk = DIST_K / k
			real passo_d = dk - d_ant
			real cv = curva3d(pos3d[p] + dk)
			vel_x = vel_x + cv * passo_d
			acum_x = acum_x + vel_x * passo_d
			d_ant = dk
			real hw = HW_BASE * k / NUM_FAIXAS
			cx3d[k] = vx0 + 200.0 - cam * hw + (acum_x / RW_MUNDO) * hw
			k = k - 1
		}
	}

	funcao desenhar_chao_3d(inteiro p, inteiro vx0)
	{
		g.definir_cor(cor_grama_e)
		g.desenhar_retangulo(vx0, HORIZONTE, VISTA_W, 600 - HORIZONTE, falso, verdadeiro)

		inteiro k = 1
		enquanto (k <= NUM_FAIXAS)
		{
			inteiro y = HORIZONTE + (k - 1) * FAIXA_PX
			real zz = pos3d[p] + DIST_K / k
			inteiro par = tp.real_para_inteiro(zz / TAM_BANDA) % 2
			inteiro par_traco = tp.real_para_inteiro(zz / TAM_TRACO) % 2
			real hw = HW_BASE * k / NUM_FAIXAS
			inteiro cxi = tp.real_para_inteiro(cx3d[k])
			inteiro hwi = tp.real_para_inteiro(hw)
			inteiro rumb = tp.real_para_inteiro(hw * 0.14)
			se (rumb < 1)
			{
				rumb = 1
			}

			// faixa clara de grama
			se (k > 8 e par == 0)
			{
				g.definir_cor(cor_grama_c)
				ret_vista(vx0, y, vx0 + VISTA_W, FAIXA_PX, vx0)
			}

			// zebras (vermelho/branco)
			se (k > 8 e par == 0)
			{
				g.definir_cor(cor_rumb_v)
			}
			senao
			{
				g.definir_cor(cor_rumb_b)
			}
			ret_vista(cxi - hwi - rumb, y, cxi - hwi, FAIXA_PX, vx0)
			ret_vista(cxi + hwi, y, cxi + hwi + rumb, FAIXA_PX, vx0)

			// asfalto
			se (par == 0)
			{
				g.definir_cor(cor_asf_a)
			}
			senao
			{
				g.definir_cor(cor_asf_b)
			}
			ret_vista(cxi - hwi, y, cxi + hwi, FAIXA_PX, vx0)

			// linhas
			se (k > 3)
			{
				inteiro lw = tp.real_para_inteiro(hw * 0.03)
				se (lw < 1)
				{
					lw = 1
				}
				inteiro borda = tp.real_para_inteiro(hw * 0.93)
				g.definir_cor(cor_faixa)
				ret_vista(cxi - borda - lw, y, cxi - borda + lw, FAIXA_PX, vx0)
				ret_vista(cxi + borda - lw, y, cxi + borda + lw, FAIXA_PX, vx0)

				se (par_traco == 0)
				{
					inteiro meio = tp.real_para_inteiro(hw * 0.5)
					ret_vista(cxi - meio - lw, y, cxi - meio + lw, FAIXA_PX, vx0)
					ret_vista(cxi - lw, y, cxi + lw, FAIXA_PX, vx0)
					ret_vista(cxi + meio - lw, y, cxi + meio + lw, FAIXA_PX, vx0)
				}
			}

			k = k + 1
		}
	}

	// -------------------------------------------------------------
	// Lista de objetos (cenário infinito gerado por uma fórmula, sem guardar nada)
	// -------------------------------------------------------------
	funcao adicionar_item_3d(real dz, real xw, inteiro tipo, inteiro variacao)
	{
		se (dz < 1.0 ou dz > 175.0 ou dl_n >= 90)
		{
			retorne
		}
		dl_z[dl_n] = dz
		dl_x[dl_n] = xw
		dl_tipo[dl_n] = tipo
		dl_var[dl_n] = variacao
		dl_n = dl_n + 1
	}

	funcao montar_lista_3d(inteiro p)
	{
		dl_n = 0
		glow_n = 0
		real pos = pos3d[p]

		inteiro idx_ini = tp.real_para_inteiro((pos + 1.0) / 7.0)
		inteiro idx_fim = tp.real_para_inteiro((pos + 175.0) / 7.0)

		para (inteiro idx = idx_ini; idx <= idx_fim; idx++)
		{
			para (inteiro lado = 0; lado < 2; lado++)
			{
				inteiro h = (idx * 13 + lado * 29 + (idx / 5) * 7) % 23
				inteiro tipo = -1
				inteiro variacao = 0

				se (h < 9)
				{
					tipo = T_PINHEIRO
					variacao = h % 2
				}
				senao se (h == 9 ou h == 10)
				{
					tipo = T_PEDRA
				}
				senao se (h == 11)
				{
					tipo = T_PLACA
				}
				senao se (h == 12 e idx % 2 == 0)
				{
					tipo = T_POSTE
				}
				senao se (h == 13 e idx % 6 == 0)
				{
					tipo = T_OUTDOOR
					variacao = (idx / 6) % 3
				}
				senao se (h == 14)
				{
					tipo = T_ARBUSTO
				}
				senao se (h == 15)
				{
					tipo = T_PLATEIA
					variacao = idx % 2
				}
				senao se (h == 16)
				{
					tipo = T_TENDA
					variacao = idx % 3
				}

				se (tipo >= 0)
				{
					real xw = 1.35 + ((idx * 7 + lado * 3) % 9) * 0.12
					se (lado == 0)
					{
						xw = -xw
					}
					adicionar_item_3d(idx * 7.0 - pos, xw, tipo, variacao)
				}
			}
		}

		para (inteiro i = 0; i < 5; i++)
		{
			adicionar_item_3d(riv_z[p][i] - pos, riv_x[p][i], T_CARRO, riv_cor[p][i])
		}
		para (inteiro i = 0; i < 4; i++)
		{
			adicionar_item_3d(cone_z[p][i] - pos, cone_x[p][i], T_CONE, 0)
		}
		para (inteiro i = 0; i < 3; i++)
		{
			adicionar_item_3d(est_z[p][i] - pos, est_x[p][i], T_ESTRELA, 0)
		}
		para (inteiro i = 0; i < 2; i++)
		{
			adicionar_item_3d(gal_z[p][i] - pos, gal_x[p][i], T_GALAO, 0)
		}
		adicionar_item_3d(prox_cp[p] - pos, 0.0, T_ARCO, 0)
	}

	// Ordena do mais longe para o mais perto (ordenação por inserção)
	funcao ordenar_lista_3d()
	{
		para (inteiro i = 0; i < dl_n; i++)
		{
			dl_ord[i] = i
		}
		para (inteiro i = 1; i < dl_n; i++)
		{
			inteiro chave = dl_ord[i]
			inteiro j = i - 1
			logico seguir_ordenando = verdadeiro
			enquanto (seguir_ordenando)
			{
				se (j < 0)
				{
					seguir_ordenando = falso
				}
				senao se (dl_z[dl_ord[j]] < dl_z[chave])
				{
					dl_ord[j + 1] = dl_ord[j]
					j = j - 1
				}
				senao
				{
					seguir_ordenando = falso
				}
			}
			dl_ord[j + 1] = chave
		}
	}

	funcao desenhar_lista_3d(inteiro vx0)
	{
		para (inteiro n = 0; n < dl_n; n++)
		{
			inteiro i = dl_ord[n]
			inteiro k = tp.real_para_inteiro(DIST_K / dl_z[i])

			se (k >= 2 e k <= NUM_FAIXAS)
			{
				real hw = HW_BASE * k / NUM_FAIXAS
				inteiro sx = tp.real_para_inteiro(cx3d[k] + dl_x[i] * hw)

				se (dl_tipo[i] == T_ARCO)
				{
					desenhar_arco_3d(k, vx0)
				}
				senao
				{
					inteiro fr = FRAME_K[k]
					se (fr >= 0)
					{
						inteiro tipo = dl_tipo[i]
						inteiro cw = SP_FW[tipo][fr]
						inteiro ch = SP_CH[tipo]
						inteiro gy = HORIZONTE + k * FAIXA_PX
						inteiro dy = gy - ch + 3
						se (tipo == T_ESTRELA ou tipo == T_GALAO)
						{
							dy = dy - bob3d * 2   // estrelas e galões "flutuam"
						}
						porcao_vista(sx - cw / 2, dy, SP_FX[tipo][fr], dl_var[i] * ch, cw, ch, img_sp[tipo], vx0)

						// poste de luz: guarda o brilho para desenhar depois da escuridão
						se (tipo == T_POSTE e w_noite > 0.25 e glow_n < 8)
						{
							real esc = ESCALA_FR[fr]
							inteiro raio = tp.real_para_inteiro(26.0 * esc) + 2
							glow_x[glow_n] = sx - tp.real_para_inteiro(26.0 * esc)
							glow_y[glow_n] = gy - tp.real_para_inteiro(130.0 * esc)
							glow_r[glow_n] = raio
							glow_n = glow_n + 1
						}
					}
				}
			}
		}
	}

	// Arco de checkpoint: desenhado com formas, ocupa a largura da pista
	funcao desenhar_arco_3d(inteiro k, inteiro vx0)
	{
		real hw = HW_BASE * k / NUM_FAIXAS
		inteiro cxi = tp.real_para_inteiro(cx3d[k])
		inteiro borda = tp.real_para_inteiro(hw * 1.08)
		inteiro gy = HORIZONTE + k * FAIXA_PX
		inteiro alt = tp.real_para_inteiro(hw * 0.62)
		inteiro lp = tp.real_para_inteiro(hw * 0.05)
		se (lp < 1)
		{
			lp = 1
		}
		inteiro esp = tp.real_para_inteiro(hw * 0.16)
		se (esp < 2)
		{
			esp = 2
		}

		g.definir_cor(cor_poste_arco)
		ret_vista(cxi - borda - lp, gy - alt, cxi - borda + lp, alt, vx0)
		ret_vista(cxi + borda - lp, gy - alt, cxi + borda + lp, alt, vx0)

		// faixa quadriculada em cima
		inteiro seg = 14
		inteiro larg_total = borda * 2
		para (inteiro r = 0; r < 2; r++)
		{
			para (inteiro s = 0; s < seg; s++)
			{
				se ((r + s) % 2 == 0)
				{
					g.definir_cor(g.COR_BRANCO)
				}
				senao
				{
					g.definir_cor(g.COR_PRETO)
				}
				inteiro xa = cxi - borda + (larg_total * s) / seg
				inteiro xb = cxi - borda + (larg_total * (s + 1)) / seg
				ret_vista(xa, gy - alt + (esp * r) / 2, xb, (esp + 1) / 2, vx0)
			}
		}
	}

	// -------------------------------------------------------------
	// Carro do jogador, poeira e freio
	// -------------------------------------------------------------
	funcao desenhar_carro_jogador_3d(inteiro p, inteiro vx0)
	{
		logico vivo = jogador1_vivo
		inteiro modelo = jogador1[_MODELO]
		se (p == 1)
		{
			vivo = jogador2_vivo
			modelo = jogador2[_MODELO]
		}
		se (nao vivo)
		{
			retorne
		}

		real cam = xp3d[p] * 0.75
		real hwc = HW_BASE * K_CARRO / NUM_FAIXAS
		inteiro px = vx0 + 200 + tp.real_para_inteiro((xp3d[p] - cam) * hwc)
		inteiro gy = HORIZONTE + K_CARRO * FAIXA_PX

		se (shake3d[p] > 0)
		{
			px = px + u.sorteia(-3, 3)
		}
		se (frames3d % 2 == 0)
		{
			gy = gy + 1   // vibração do motor
		}

		// poeira quando está fora da pista
		se (xp3d[p] > 1.02 ou xp3d[p] < -1.02)
		{
			g.definir_cor(cor_poeira)
			g.definir_opacidade(110)
			para (inteiro i = 0; i < 6; i++)
			{
				inteiro ex = px - 46 + u.sorteia(0, 80)
				inteiro ey = gy - 14 + u.sorteia(0, 14)
				inteiro er = 8 + u.sorteia(0, 12)
				g.desenhar_elipse(ex, ey, er, er, verdadeiro)
			}
			g.definir_opacidade(255)
		}

		// pisca enquanto está invulnerável
		se (invul3d[p] > 0 e ((invul3d[p] / 4) % 2) == 0)
		{
			retorne
		}

		inteiro cor_carro = modelo
		se (cor_carro < 0 ou cor_carro > 23)
		{
			cor_carro = 0
		}
		inteiro fr = FRAME_K[K_CARRO]
		inteiro cw = SP_FW[T_CARRO][fr]
		inteiro ch = SP_CH[T_CARRO]
		porcao_vista(px - cw / 2, gy - ch + 3, SP_FX[T_CARRO][fr], cor_carro * ch, cw, ch, img_sp[T_CARRO], vx0)

		// luz de freio
		se (freando3d[p])
		{
			g.definir_cor(cor_freio)
			g.definir_opacidade(190)
			ret_vista(px - 37, gy - 31, px - 20, 10, vx0)
			ret_vista(px + 20, gy - 31, px + 37, 10, vx0)
			g.definir_opacidade(255)
		}
	}

	// -------------------------------------------------------------
	// Efeitos de tempo: noite, entardecer, faróis, brilhos e chuva
	// -------------------------------------------------------------
	funcao desenhar_noite_3d(inteiro vx0)
	{
		real w_tarde = 1.0 - w_dia - w_noite
		se (w_tarde > 0.05)
		{
			g.definir_cor(cor_tarde)
			g.definir_opacidade(tp.real_para_inteiro(w_tarde * 45.0))
			ret_vista(vx0, HORIZONTE - 112, vx0 + VISTA_W, 600 - (HORIZONTE - 112), vx0)
			g.definir_opacidade(255)
		}
		se (w_noite > 0.02)
		{
			g.definir_cor(cor_noite)
			g.definir_opacidade(tp.real_para_inteiro(w_noite * 135.0))
			ret_vista(vx0, HORIZONTE - 112, vx0 + VISTA_W, 600 - (HORIZONTE - 112), vx0)
			g.definir_opacidade(255)
		}
	}

	funcao desenhar_farois_3d(inteiro p, inteiro vx0)
	{
		se (w_noite > 0.25)
		{
			g.definir_cor(cor_farol)
			para (inteiro k = 18; k <= 60; k = k + 6)
			{
				real hwk = HW_BASE * k / NUM_FAIXAS
				inteiro cxl = tp.real_para_inteiro(cx3d[k] + xp3d[p] * hwk)
				inteiro meia = tp.real_para_inteiro(hwk * 0.42)
				inteiro yk = HORIZONTE + (k - 1) * FAIXA_PX

				g.definir_opacidade(tp.real_para_inteiro(26.0 * w_noite))
				ret_vista(cxl - meia, yk, cxl + meia, 6 * FAIXA_PX, vx0)
				g.definir_opacidade(tp.real_para_inteiro(30.0 * w_noite))
				ret_vista(cxl - meia / 2, yk, cxl + meia / 2, 6 * FAIXA_PX, vx0)
			}
			g.definir_opacidade(255)
		}
	}

	funcao desenhar_brilhos_3d(inteiro vx0)
	{
		g.definir_cor(cor_farol)
		g.definir_opacidade(80)
		para (inteiro i = 0; i < glow_n; i++)
		{
			se (glow_x[i] > vx0 + 30 e glow_x[i] < vx0 + VISTA_W - 30)
			{
				g.desenhar_elipse(glow_x[i] - glow_r[i], glow_y[i] - glow_r[i], glow_r[i] * 2, glow_r[i] * 2, verdadeiro)
			}
		}
		g.definir_opacidade(255)
	}

	funcao desenhar_chuva_3d(inteiro vx0)
	{
		se (chuva3d)
		{
			g.definir_cor(cor_chuva)
			g.definir_opacidade(chuva_nivel)
			ret_vista(vx0, 0, vx0 + VISTA_W, 600, vx0)
			g.definir_opacidade(255)

			se (chuva_nivel > 20)
			{
				inteiro off = (frames3d * 22) % 600
				g.desenhar_imagem(vx0, off - 600, img_chuva)
				g.desenhar_imagem(vx0, off, img_chuva)
			}
		}
	}

	// -------------------------------------------------------------
	// HUD e avisos
	// -------------------------------------------------------------
	funcao desenhar_hud_3d(inteiro p, inteiro vx0)
	{
		cadeia nome = "P1"
		real pontos = pontuacao_p1
		inteiro vidas = vidas_p1
		inteiro estrelas = estrelas_p1_qtd
		real comb = combustivel_p1
		real vel = velocidade_p1
		logico vivo = jogador1_vivo
		se (p == 1)
		{
			nome = "P2"
			pontos = pontuacao_p2
			vidas = vidas_p2
			estrelas = estrelas_p2_qtd
			comb = combustivel_p2
			vel = velocidade_p2
			vivo = jogador2_vivo
		}

		desenhar_painel(vx0 + 8, 6, 206, 196, 140)
		desenhar_texto_com_sombra(vx0 + 15, 10, nome + "  " + tp.real_para_inteiro(pontos) + " m", g.COR_AMARELO, 20.0, verdadeiro)

		// vidas (corações)
		se (vivo)
		{
			para (inteiro i = 0; i < vidas; i++)
			{
				g.desenhar_porcao_imagem(vx0 + 15 + i * 27, 38, 0, 0, 28, 28, img_hud_icones)
			}
		}

		// combustível
		g.desenhar_porcao_imagem(vx0 + 15, 76, 28, 0, 28, 28, img_hud_icones)
		desenhar_medidor_combustivel(vx0 + 50, 90, comb)

		// estrelas
		g.desenhar_porcao_imagem(vx0 + 15, 106, 56, 0, 28, 28, img_hud_icones)
		desenhar_texto_com_sombra(vx0 + 50, 110, "x " + estrelas, g.COR_AMARELO, 18.0, verdadeiro)

		// hora do dia / clima
		inteiro icone = 4
		cadeia txt_clima = "Dia"
		se (chuva3d e chuva_nivel > 20)
		{
			icone = 6
			txt_clima = "Chuva"
		}
		senao se (w_noite > 0.5)
		{
			icone = 5
			txt_clima = "Noite"
		}
		senao se (w_dia < 0.5)
		{
			icone = 7
			txt_clima = "Entardecer"
		}
		g.desenhar_porcao_imagem(vx0 + 15, 136, icone * 28, 0, 28, 28, img_hud_icones)
		desenhar_texto_com_sombra(vx0 + 50, 141, txt_clima, g.COR_BRANCO, 16.0, verdadeiro)

		// próximo checkpoint
		inteiro falta = tp.real_para_inteiro(prox_cp[p] - (pos3d[p] + Z_CARRO))
		se (falta < 0)
		{
			falta = 0
		}
		g.desenhar_porcao_imagem(vx0 + 15, 166, 84, 0, 28, 28, img_hud_icones)
		desenhar_texto_com_sombra(vx0 + 50, 171, "CP " + cp_count[p] + "  (" + falta + " m)", g.COR_BRANCO, 16.0, verdadeiro)

		// velocímetro analógico
		se (vivo)
		{
			inteiro gx = vx0 + 262
			inteiro gyy = 456
			g.desenhar_imagem(gx, gyy, img_painel_vel)

			real razao = (vel * 8.0) / 240.0
			se (razao > 1.0)
			{
				razao = 1.0
			}
			inteiro n_ag = tp.real_para_inteiro(razao * 32.0)
			inteiro ax = gx + 66
			inteiro ay = gyy + 66
			g.definir_cor(g.COR_VERMELHO)
			g.desenhar_linha(ax, ay, ax + AGULHA_DX[n_ag] - 50, ay + AGULHA_DY[n_ag] - 50)
			g.desenhar_linha(ax + 1, ay + 1, ax + AGULHA_DX[n_ag] - 49, ay + AGULHA_DY[n_ag] - 49)
			g.definir_cor(g.COR_BRANCO)
			g.desenhar_elipse(ax - 5, ay - 5, 10, 10, verdadeiro)

			inteiro kmh = tp.real_para_inteiro(vel * 8.0)
			desenhar_texto_com_sombra(gx + 44, gyy + 86, "" + kmh, g.COR_BRANCO, 18.0, verdadeiro)
		}
	}

	funcao desenhar_avisos_3d(inteiro p, inteiro vx0)
	{
		logico vivo = jogador1_vivo
		se (p == 1)
		{
			vivo = jogador2_vivo
		}

		se (vivo)
		{
			inteiro vid3 = vidas_p1
			real comb3 = combustivel_p1
			se (p == 1)
			{
				vid3 = vidas_p2
				comb3 = combustivel_p2
			}
			desenhar_flash_dano(p, vx0, vid3)
			desenhar_alerta_combustivel(vx0, comb3)
		}

		// banner de checkpoint
		se (cp_banner[p] > 0 e vivo)
		{
			texto_vista(vx0, 205, "CHECKPOINT " + cp_count[p] + "!", g.COR_AMARELO, 26.0)
			texto_vista(vx0, 238, "+ combustível", g.COR_VERDE, 16.0)
		}

		// semáforo da largada
		inteiro tl = u.tempo_decorrido() - t_largada_ms
		se (tl < 2800)
		{
			inteiro estado = 3
			cadeia aviso = "VAI!"
			se (tl < 1000)
			{
				estado = 1
				aviso = "PREPARE-SE..."
			}
			senao se (tl < 2000)
			{
				estado = 2
				aviso = "ATENÇÃO..."
			}
			g.desenhar_porcao_imagem(vx0 + 167, 60, estado * 66, 0, 66, 150, img_semaforo)
			texto_vista(vx0, 220, aviso, g.COR_BRANCO, 22.0)
		}

		// jogador fora da corrida
		se (nao vivo)
		{
			g.definir_cor(g.COR_PRETO)
			g.definir_opacidade(150)
			ret_vista(vx0, 0, vx0 + VISTA_W, 600, vx0)
			g.definir_opacidade(255)
			texto_vista(vx0, 270, "FIM DE JOGO", g.COR_VERMELHO, 28.0)
		}
	}

	// -------------------------------------------------------------
	// Interface: carregamento e ferramentas
	// -------------------------------------------------------------
	funcao carregar_imagens_ui()
	{
		NOMES_SKINS[0] = "Relâmpago Azul"
		NOMES_SKINS[1] = "Fogo Vermelho"
		NOMES_SKINS[2] = "Táxi Urbano"
		NOMES_SKINS[3] = "Soldado Verde"
		NOMES_SKINS[4] = "Neon Roxo"
		NOMES_SKINS[5] = "Zebra Branca"
		NOMES_SKINS[6] = "Laranja Sete"
		NOMES_SKINS[7] = "Grafite Fosco"
		NOMES_SKINS[8] = "Retrô Rosa"
		NOMES_SKINS[9] = "Turquesa Urbano"
		NOMES_SKINS[10] = "Patrulha"
		NOMES_SKINS[11] = "Picape Barro"
		NOMES_SKINS[12] = "Perua Verde"
		NOMES_SKINS[13] = "Raio Amarelo"
		NOMES_SKINS[14] = "Marinho Executivo"
		NOMES_SKINS[15] = "Selva Rally"
		NOMES_SKINS[16] = "Retrô Celeste"
		NOMES_SKINS[17] = "Hatch Chamas"
		NOMES_SKINS[18] = "Prata Coupé"
		NOMES_SKINS[19] = "Picape Marítima"
		NOMES_SKINS[20] = "Bombeiro"
		NOMES_SKINS[21] = "Noite Dourada"
		NOMES_SKINS[22] = "Perua Laranja"
		NOMES_SKINS[23] = "Escola de Pilotos"
		cadeia pasta = "corrida/imagens_ui/"
		img_ui_ic = g.carregar_imagem(pasta + "ui_icones.png")
		img_ui_icg = g.carregar_imagem(pasta + "ui_icones_g.png")
		img_trofeu = g.carregar_imagem(pasta + "trofeu.png")
		img_podio = g.carregar_imagem(pasta + "podio.png")
		img_go_bg = g.carregar_imagem(pasta + "game_over_bg.jpg")
		img_menu_vig = g.carregar_imagem(pasta + "menu_vinheta.png")
		img_jogo_vig = g.carregar_imagem(pasta + "jogo_vinheta.png")
		img_xadrez = g.carregar_imagem(pasta + "xadrez.png")
		img_brilho = g.carregar_imagem(pasta + "brilho.png")
		img_fumaca = g.carregar_imagem(pasta + "fumaca.png")

		cor_pn_fundo = g.criar_cor(12, 14, 26)
		cor_pn_borda = g.criar_cor(120, 132, 176)
		cor_ouro = g.criar_cor(255, 196, 40)
		cor_ok = g.criar_cor(46, 170, 92)
		cor_ruim = g.criar_cor(230, 70, 70)
		cor_texto_fraco = g.criar_cor(170, 178, 204)
		cor_azul_p1 = g.criar_cor(46, 120, 230)
		cor_laranja_p2 = g.criar_cor(240, 130, 30)
		cor_divisoria = g.criar_cor(16, 18, 28)
	}

	funcao liberar_imagens_ui()
	{
		g.liberar_imagem(img_ui_ic)
		g.liberar_imagem(img_ui_icg)
		g.liberar_imagem(img_trofeu)
		g.liberar_imagem(img_podio)
		g.liberar_imagem(img_go_bg)
		g.liberar_imagem(img_menu_vig)
		g.liberar_imagem(img_jogo_vig)
		g.liberar_imagem(img_xadrez)
		g.liberar_imagem(img_brilho)
		g.liberar_imagem(img_fumaca)
	}

	// modo: 0 = Corrida 2D, 1 = Corrida 3D
	funcao reiniciar_ui_corrida(inteiro modo)
	{
		vidas_ant[0] = -1
		vidas_ant[1] = -1
		flash_dano[0] = 0
		flash_dano[1] = 0
		inicio_2d_ms = u.tempo_decorrido()
		modo_ultima_corrida = modo
		w_dia = 1.0
		w_noite = 0.0
		chuva3d = falso
		chuva_nivel = 0
		idx_ceu = 0
	}

	funcao registrar_resultado()
	{
		novo_recorde_p1 = falso
		novo_recorde_p2 = falso
		real melhor = pontuacao_p1
		se (pontuacao_p2 > melhor)
		{
			melhor = pontuacao_p2
		}
		se (melhor > recorde_dist)
		{
			recorde_dist = melhor
			se (pontuacao_p1 >= pontuacao_p2)
			{
				novo_recorde_p1 = verdadeiro
			}
			senao
			{
				novo_recorde_p2 = verdadeiro
			}
		}
	}

	// ícones de 24 px e de 40 px (índices: 0 cadeado, 1 ok, 2 seta esq, 3 seta dir, 4 estrela,
	// 5 coração, 6 combustível, 7 velocímetro, 8 2x, 9 troféu, 10 X, 11 bandeira, 12 carro,
	// 13 coroa, 14 brilho, 15 relógio)
	funcao icone_ui(inteiro x, inteiro y, inteiro idx)
	{
		g.desenhar_porcao_imagem(x, y, idx * 24, 0, 24, 24, img_ui_ic)
	}

	funcao icone_ui_g(inteiro x, inteiro y, inteiro idx)
	{
		g.desenhar_porcao_imagem(x, y, idx * 40, 0, 40, 40, img_ui_icg)
	}

	funcao texto_em(inteiro xc, inteiro y, cadeia texto, inteiro cor, real tamanho, logico sombra)
	{
		g.definir_tamanho_texto(tamanho)
		inteiro lt = g.largura_texto(texto)
		desenhar_texto_com_sombra(xc - lt / 2, y, texto, cor, tamanho, sombra)
	}

	// Painel translúcido com cantos arredondados
	funcao desenhar_painel(inteiro x, inteiro y, inteiro larg, inteiro alt, inteiro opac)
	{
		g.definir_cor(cor_pn_fundo)
		g.definir_opacidade(opac)
		g.desenhar_retangulo(x, y, larg, alt, verdadeiro, verdadeiro)
		g.definir_cor(cor_pn_borda)
		g.definir_opacidade(170)
		g.desenhar_retangulo(x, y, larg, alt, verdadeiro, falso)
		g.definir_opacidade(255)
	}

	// Barrinhas de nível (ex.: 3 de 5)
	funcao desenhar_pips(inteiro x, inteiro y, inteiro nivel, inteiro maximo)
	{
		para (inteiro i = 0; i < maximo; i++)
		{
			se (i < nivel)
			{
				g.definir_cor(cor_ouro)
			}
			senao
			{
				g.definir_cor(cor_pn_fundo)
			}
			g.desenhar_retangulo(x + i * 24, y, 20, 11, verdadeiro, verdadeiro)
			g.definir_cor(cor_pn_borda)
			g.desenhar_retangulo(x + i * 24, y, 20, 11, verdadeiro, falso)
		}
	}

	// Fundo comum das telas de menu (imagem + escurecimento + vinheta + faixas animadas)
	funcao desenhar_fundo_ui()
	{
		g.desenhar_imagem(0, 0, imagem_fundo_menu)
		g.definir_cor(g.COR_PRETO)
		g.definir_opacidade(150)
		g.desenhar_retangulo(0, 0, LARGURA, ALTURA, falso, verdadeiro)
		g.definir_opacidade(255)
		g.desenhar_imagem(0, 0, img_menu_vig)
		faixas_xadrez_ui()
	}

	funcao faixas_xadrez_ui()
	{
		faixa_loop(img_xadrez, 800, 16, 0, tempo_ui * 2, 0)
		faixa_loop(img_xadrez, 800, 16, 0, tempo_ui * 2, 400)
		faixa_loop(img_xadrez, 800, 16, 584, 0 - tempo_ui * 2, 0)
		faixa_loop(img_xadrez, 800, 16, 584, 0 - tempo_ui * 2, 400)
	}

	// -------------------------------------------------------------
	// Efeitos do modo 2D: sombras, luzes, velocidade, tempo
	// -------------------------------------------------------------
	funcao desenhar_sombra_obj(inteiro x, inteiro y, inteiro larg, inteiro alt)
	{
		g.definir_cor(g.COR_PRETO)
		g.definir_opacidade(70)
		g.desenhar_elipse(x + 3, y + alt - 12, larg, 22, verdadeiro)
		g.definir_opacidade(255)
	}

	funcao desenhar_efeito_tempo_2d()
	{
		real w_tarde = 1.0 - w_dia - w_noite
		se (w_tarde > 0.05)
		{
			g.definir_cor(cor_tarde)
			g.definir_opacidade(tp.real_para_inteiro(w_tarde * 55.0))
			g.desenhar_retangulo(0, 0, LARGURA, ALTURA, falso, verdadeiro)
		}
		se (w_noite > 0.02)
		{
			g.definir_cor(cor_noite)
			g.definir_opacidade(tp.real_para_inteiro(w_noite * 125.0))
			g.desenhar_retangulo(0, 0, LARGURA, ALTURA, falso, verdadeiro)
		}
		g.definir_opacidade(255)
	}

	funcao desenhar_farois_2d()
	{
		se (w_noite > 0.2)
		{
			g.definir_cor(cor_farol)
			para (inteiro p = 0; p < 2; p++)
			{
				logico vivo = jogador1_vivo
				inteiro cxl = jogador1[_X] + MODELOS_VEICULOS[jogador1[_MODELO]][_LARGURA] / 2
				inteiro cyl = jogador1[_Y]
				se (p == 1)
				{
					vivo = jogador2_vivo
					cxl = jogador2[_X] + MODELOS_VEICULOS[jogador2[_MODELO]][_LARGURA] / 2
					cyl = jogador2[_Y]
				}
				se (vivo)
				{
					para (inteiro i = 0; i < 9; i++)
					{
						inteiro larg = 60 + i * 16
						g.definir_opacidade(tp.real_para_inteiro(w_noite * (46 - i * 4)))
						ret_vista(cxl - larg / 2, cyl - 28 - i * 32, cxl + larg / 2, 32, p * VISTA_W)
					}
				}
			}
			g.definir_opacidade(255)
		}
	}

	funcao desenhar_linhas_velocidade()
	{
		para (inteiro p = 0; p < 2; p++)
		{
			real vel = velocidade_p1
			logico vivo = jogador1_vivo
			se (p == 1)
			{
				vel = velocidade_p2
				vivo = jogador2_vivo
			}
			se (vivo e vel > 15.0)
			{
				g.definir_cor(g.COR_BRANCO)
				g.definir_opacidade(tp.real_para_inteiro((vel - 15.0) * 6.0))
				para (inteiro i = 0; i < 6; i++)
				{
					inteiro lx = p * VISTA_W + 24 + ((i * 97 + 13) % 352)
					inteiro ly = ((tempo_ui * tp.real_para_inteiro(vel) + i * 131) % 700) - 80
					g.desenhar_retangulo(lx, ly, 2, 60, falso, verdadeiro)
				}
				g.definir_opacidade(255)
			}
		}
	}

	// Aviso de dano (tela vermelha) quando perde uma vida
	funcao desenhar_flash_dano(inteiro p, inteiro vx0, inteiro vidas)
	{
		se (vidas_ant[p] < 0)
		{
			vidas_ant[p] = vidas
		}
		se (vidas < vidas_ant[p])
		{
			flash_dano[p] = 14
		}
		vidas_ant[p] = vidas
		se (flash_dano[p] > 0)
		{
			g.definir_cor(g.COR_VERMELHO)
			g.definir_opacidade(flash_dano[p] * 9)
			ret_vista(vx0, 0, vx0 + VISTA_W, 600, vx0)
			g.definir_opacidade(255)
			flash_dano[p] = flash_dano[p] - 1
		}
	}

	// Moldura vermelha piscando com pouco combustível
	funcao desenhar_alerta_combustivel(inteiro vx0, real comb)
	{
		se (comb < MAXIMO_COMBUSTIVEL * 0.25 e comb > 0.0 e (tempo_ui / 10) % 2 == 0)
		{
			g.definir_cor(g.COR_VERMELHO)
			g.definir_opacidade(110)
			ret_vista(vx0, 0, vx0 + VISTA_W, 6, vx0)
			ret_vista(vx0, 594, vx0 + VISTA_W, 6, vx0)
			ret_vista(vx0, 0, vx0 + 6, 600, vx0)
			ret_vista(vx0 + VISTA_W - 6, 0, vx0 + VISTA_W, 600, vx0)
			g.definir_opacidade(255)
			texto_em(vx0 + 200, 150, "COMBUSTÍVEL BAIXO!", g.COR_VERMELHO, 18.0, verdadeiro)
		}
	}

	funcao desenhar_avisos_2d()
	{
		para (inteiro p = 0; p < 2; p++)
		{
			inteiro vx0 = p * VISTA_W
			logico vivo = jogador1_vivo
			inteiro vid = vidas_p1
			real comb = combustivel_p1
			real pontos = pontuacao_p1
			se (p == 1)
			{
				vivo = jogador2_vivo
				vid = vidas_p2
				comb = combustivel_p2
				pontos = pontuacao_p2
			}

			se (vivo)
			{
				desenhar_flash_dano(p, vx0, vid)
				desenhar_alerta_combustivel(vx0, comb)
			}
			senao
			{
				g.definir_cor(g.COR_PRETO)
				g.definir_opacidade(150)
				ret_vista(vx0, 0, vx0 + VISTA_W, 600, vx0)
				g.definir_opacidade(255)
				icone_ui_g(vx0 + 180, 238, 10)
				texto_em(vx0 + 200, 290, "ELIMINADO", g.COR_VERMELHO, 28.0, verdadeiro)
				texto_em(vx0 + 200, 330, "" + tp.real_para_inteiro(pontos) + " m", g.COR_AMARELO, 20.0, verdadeiro)
			}
		}
	}

	// -------------------------------------------------------------
	// HUD do modo 2D
	// -------------------------------------------------------------
	funcao desenhar_hud_jogador(inteiro x0, cadeia nome, inteiro cor_nome, real pontos, inteiro vidas, inteiro estrelas, real comb, real vel, logico vivo)
	{
		desenhar_painel(x0 + 8, 8, 206, 128, 150)

		g.definir_cor(cor_nome)
		g.desenhar_retangulo(x0 + 16, 15, 34, 24, verdadeiro, verdadeiro)
		desenhar_texto_com_sombra(x0 + 22, 18, nome, g.COR_BRANCO, 16.0, falso)
		desenhar_texto_com_sombra(x0 + 60, 13, "" + tp.real_para_inteiro(pontos) + " m", g.COR_AMARELO, 22.0, verdadeiro)

		se (vivo)
		{
			para (inteiro i = 0; i < vidas; i++)
			{
				icone_ui(x0 + 16 + i * 21, 44, 5)
			}
			icone_ui(x0 + 150, 44, 4)
			desenhar_texto_com_sombra(x0 + 176, 47, "x" + estrelas, g.COR_AMARELO, 16.0, verdadeiro)

			icone_ui(x0 + 14, 74, 6)
			desenhar_medidor_combustivel(x0 + 46, 90, comb)

			icone_ui(x0 + 14, 104, 7)
			inteiro kmh = tp.real_para_inteiro(vel * 8.0)
			inteiro cor_vel = g.COR_VERDE
			se (vel > 13.0)
			{
				cor_vel = g.COR_VERMELHO
			}
			senao se (vel < 11.0)
			{
				cor_vel = cor_azul_p1
			}
			desenhar_texto_com_sombra(x0 + 46, 107, "" + kmh + " km/h", cor_vel, 15.0, verdadeiro)

			real razao = vel / 36.0
			se (razao > 1.0)
			{
				razao = 1.0
			}
			g.definir_cor(cor_pn_fundo)
			g.desenhar_retangulo(x0 + 138, 112, 66, 7, verdadeiro, verdadeiro)
			g.definir_cor(cor_vel)
			g.desenhar_retangulo(x0 + 138, 112, tp.real_para_inteiro(66.0 * razao), 7, verdadeiro, verdadeiro)
		}
	}

	// -------------------------------------------------------------
	// Menu, skins, melhorias e derrota
	// -------------------------------------------------------------
	funcao desenhar_botao_menu(inteiro y, cadeia texto, inteiro icone, logico sel)
	{
		inteiro bw = 380
		inteiro bh = 46
		inteiro bx = (LARGURA - bw) / 2
		inteiro pulso = (tempo_ui / 6) % 8
		se (pulso > 4)
		{
			pulso = 8 - pulso
		}

		se (sel)
		{
			g.definir_cor(cor_ouro)
			g.definir_opacidade(40 + pulso * 10)
			g.desenhar_retangulo(bx - 6, y - 6, bw + 12, bh + 12, verdadeiro, verdadeiro)
			g.definir_opacidade(245)
			g.desenhar_retangulo(bx, y, bw, bh, verdadeiro, verdadeiro)
			g.definir_opacidade(255)
			icone_ui_g(bx + 12 + pulso, y + 3, icone)
			texto_em(LARGURA / 2, y + 10, texto, cor_pn_fundo, 24.0, falso)
			icone_ui(bx + bw - 38, y + 11, 3)
		}
		senao
		{
			desenhar_painel(bx, y, bw, bh, 160)
			icone_ui_g(bx + 12, y + 3, icone)
			texto_em(LARGURA / 2, y + 10, texto, g.COR_BRANCO, 24.0, verdadeiro)
		}
	}

	funcao desenhar_menu()
	{
		se (opcao_menu == 3)
		{
			g.desenhar_imagem(0, 0, img_fundo_menu_3d)
		}
		senao
		{
			g.desenhar_imagem(0, 0, imagem_fundo_menu)
		}
		g.desenhar_imagem(0, 0, img_menu_vig)
		faixas_xadrez_ui()

		// estrelas guardadas de cada jogador
		desenhar_painel(14, 26, 118, 30, 150)
		icone_ui(20, 29, 4)
		desenhar_texto_com_sombra(50, 33, "P1  " + banco_estrelas_p1, g.COR_AMARELO, 16.0, verdadeiro)
		desenhar_painel(668, 26, 118, 30, 150)
		icone_ui(674, 29, 4)
		desenhar_texto_com_sombra(704, 33, "P2  " + banco_estrelas_p2, g.COR_AMARELO, 16.0, verdadeiro)

		// logo com brilho e leve balanço
		inteiro bal = (tempo_ui / 10) % 8
		se (bal > 4)
		{
			bal = 8 - bal
		}
		inteiro largura_logo = g.largura_imagem(imagem_logo)
		inteiro x_logo = (LARGURA / 2) - (largura_logo / 2)
		g.definir_cor(cor_ouro)
		g.definir_opacidade(28)
		g.desenhar_elipse(250, 150 + bal, 300, 130, verdadeiro)
		g.definir_opacidade(255)
		g.desenhar_imagem(x_logo, 24 + bal, imagem_logo)

		desenhar_botao_menu(300, "JOGAR", 11, opcao_menu == 0)
		desenhar_botao_menu(356, "SKINS", 12, opcao_menu == 1)
		desenhar_botao_menu(412, "MELHORIAS", 7, opcao_menu == 2)
		desenhar_botao_menu(468, "CORRIDA 3D", 14, opcao_menu == 3)

		cadeia desc = ""
		escolha (opcao_menu)
		{
			caso 0:
				desc = "Corrida clássica para dois jogadores, com dia, noite e chuva"
				pare
			caso 1:
				desc = "Compre e equipe novos carros com as estrelas coletadas"
				pare
			caso 2:
				desc = "Melhore vidas, tanque, velocidade máxima e bônus de estrelas"
				pare
			caso 3:
				desc = "NOVO: perspectiva 3D, curvas, checkpoints e tela dividida"
				pare
		}
		desenhar_painel(100, 526, 600, 28, 165)
		texto_em(LARGURA / 2, 531, desc, g.COR_AMARELO, 15.0, falso)
		texto_em(LARGURA / 2, 562, "W/S ou setas: escolher   |   ENTER: confirmar   |   ESC: sair", cor_texto_fraco, 13.0, falso)
	}

	funcao desenhar_card_skin(inteiro x0, cadeia nome, cadeia ctrl, cadeia tecla, inteiro banco, inteiro vis, inteiro equip, logico desbloq)
	{
		desenhar_painel(x0 + 20, 96, 360, 410, 165)

		icone_ui_g(x0 + 32, 106, 12)
		desenhar_texto_com_sombra(x0 + 80, 108, nome, g.COR_BRANCO, 22.0, verdadeiro)
		desenhar_texto_com_sombra(x0 + 80, 134, ctrl, cor_texto_fraco, 13.0, falso)

		desenhar_painel(x0 + 262, 110, 108, 30, 170)
		icone_ui(x0 + 268, 113, 4)
		desenhar_texto_com_sombra(x0 + 298, 117, "" + banco, g.COR_AMARELO, 16.0, verdadeiro)

		// número e nome da skin
		desenhar_texto_com_sombra(x0 + 36, 168, "SKIN " + (vis + 1) + " / 24", cor_texto_fraco, 14.0, falso)
		desenhar_texto_com_sombra(x0 + 36, 192, NOMES_SKINS[vis], g.COR_BRANCO, 17.0, verdadeiro)

		// prévia da mesma skin no modo 3D (vista traseira)
		desenhar_painel(x0 + 218, 154, 152, 112, 190)
		desenhar_texto_com_sombra(x0 + 232, 158, "VISÃO 3D", cor_texto_fraco, 12.0, falso)
		inteiro prev_w = SP_FW[T_CARRO][14]
		inteiro prev_h = SP_CH[T_CARRO]
		inteiro prev_x = x0 + 294 - prev_w / 2
		g.desenhar_porcao_imagem(prev_x, 188, SP_FX[T_CARRO][14], vis * prev_h, prev_w, prev_h, img_sp[T_CARRO])
		se (nao desbloq)
		{
			g.definir_cor(g.COR_PRETO)
			g.definir_opacidade(140)
			g.desenhar_retangulo(prev_x, 188, prev_w, prev_h, falso, verdadeiro)
			g.definir_opacidade(255)
			icone_ui(x0 + 282, 188 + prev_h / 2 - 12, 0)
		}

		g.desenhar_imagem(x0 + 40, 300, img_podio)

		inteiro w = MODELOS_VEICULOS[vis][_LARGURA]
		inteiro h = MODELOS_VEICULOS[vis][_ALTURA]
		inteiro cxs = x0 + 200
		inteiro base = 420
		g.desenhar_porcao_imagem(cxs - w / 2, base - h, MODELOS_VEICULOS[vis][_SX], MODELOS_VEICULOS[vis][_SY], w, h, imagem_veiculos)
		se (nao desbloq)
		{
			g.definir_cor(g.COR_PRETO)
			g.definir_opacidade(150)
			g.desenhar_retangulo(cxs - w / 2, base - h, w, h, falso, verdadeiro)
			g.definir_opacidade(255)
			icone_ui_g(cxs - 20, base - h / 2 - 20, 0)
		}

		inteiro bal = (tempo_ui / 8) % 6
		se (bal > 3)
		{
			bal = 6 - bal
		}
		icone_ui_g(x0 + 34 - bal, 330, 2)
		icone_ui_g(x0 + 326 + bal, 330, 3)

		se (equip == vis)
		{
			g.definir_cor(cor_ok)
			g.desenhar_retangulo(x0 + 80, 452, 240, 36, verdadeiro, verdadeiro)
			icone_ui(x0 + 92, 458, 1)
			texto_em(x0 + 212, 460, "EQUIPADA", g.COR_BRANCO, 18.0, verdadeiro)
		}
		senao se (desbloq)
		{
			desenhar_painel(x0 + 80, 452, 240, 36, 200)
			texto_em(x0 + 200, 460, tecla + " EQUIPAR", g.COR_BRANCO, 17.0, verdadeiro)
		}
		senao se (banco >= PRECO_SKIN)
		{
			g.definir_cor(cor_ouro)
			g.desenhar_retangulo(x0 + 80, 452, 240, 36, verdadeiro, verdadeiro)
			icone_ui(x0 + 92, 458, 4)
			texto_em(x0 + 212, 460, tecla + " COMPRAR  (" + PRECO_SKIN + ")", cor_pn_fundo, 17.0, falso)
		}
		senao
		{
			desenhar_painel(x0 + 80, 452, 240, 36, 200)
			icone_ui(x0 + 92, 458, 0)
			texto_em(x0 + 212, 460, "FALTAM " + (PRECO_SKIN - banco) + " ESTRELAS", cor_ruim, 15.0, verdadeiro)
		}
	}

	funcao desenhar_skins()
	{
		desenhar_fundo_ui()
		desenhar_divisoria()

		g.definir_tamanho_texto(34.0)
		inteiro lt = g.largura_texto("LOJA DE SKINS")
		icone_ui_g(400 - lt / 2 - 52, 34, 12)
		icone_ui_g(400 + lt / 2 + 14, 34, 12)
		texto_em(400, 36, "LOJA DE SKINS", g.COR_AMARELO, 34.0, verdadeiro)

		desenhar_card_skin(0, "Jogador 1", "A / D trocar  |  W equipar", "[W]", banco_estrelas_p1, visualizando_skin_p1, jogador1[_MODELO], skins_desbloqueadas_p1[visualizando_skin_p1])
		desenhar_card_skin(400, "Jogador 2", "Esq / Dir trocar  |  Cima equipar", "[CIMA]", banco_estrelas_p2, visualizando_skin_p2, jogador2[_MODELO], skins_desbloqueadas_p2[visualizando_skin_p2])

		desenhar_painel(290, 534, 220, 30, 170)
		texto_em(400, 540, "ENTER para voltar", g.COR_VERDE, 17.0, falso)
	}

	funcao desenhar_linha_melhoria(inteiro x, inteiro y, cadeia nome, inteiro icone, inteiro nivel, inteiro maximo, inteiro custo, inteiro banco, logico sel, logico eh_mult)
	{
		se (sel)
		{
			g.definir_cor(cor_ouro)
			g.definir_opacidade(80)
			g.desenhar_retangulo(x - 4, y - 4, 334, 72, verdadeiro, verdadeiro)
			g.definir_opacidade(255)
			desenhar_painel(x, y, 326, 64, 225)
		}
		senao
		{
			desenhar_painel(x, y, 326, 64, 150)
		}

		icone_ui_g(x + 10, y + 12, icone)

		se (sel)
		{
			desenhar_texto_com_sombra(x + 60, y + 8, nome, cor_ouro, 17.0, verdadeiro)
		}
		senao
		{
			desenhar_texto_com_sombra(x + 60, y + 8, nome, g.COR_BRANCO, 17.0, verdadeiro)
		}

		se (eh_mult)
		{
			se (nivel >= 1)
			{
				desenhar_texto_com_sombra(x + 60, y + 36, "ADQUIRIDO", cor_ok, 15.0, verdadeiro)
			}
			senao
			{
				desenhar_texto_com_sombra(x + 60, y + 36, "Dobra as estrelas coletadas", cor_texto_fraco, 13.0, falso)
			}
		}
		senao
		{
			desenhar_pips(x + 60, y + 38, nivel, maximo)
		}

		se (nivel >= maximo)
		{
			desenhar_texto_com_sombra(x + 268, y + 22, "MÁX", cor_ouro, 20.0, verdadeiro)
		}
		senao
		{
			inteiro cor_custo = cor_ruim
			se (banco >= custo)
			{
				cor_custo = g.COR_VERDE
			}
			icone_ui(x + 250, y + 34, 4)
			desenhar_texto_com_sombra(x + 278, y + 37, "" + custo, cor_custo, 17.0, verdadeiro)
		}
	}

	funcao desenhar_card_melhorias(inteiro x0, cadeia nome, cadeia ctrl, inteiro banco, inteiro sel, inteiro n_vida, inteiro n_comb, inteiro n_vel, logico mult)
	{
		desenhar_painel(x0 + 20, 96, 360, 410, 165)

		icone_ui_g(x0 + 32, 106, 12)
		desenhar_texto_com_sombra(x0 + 80, 108, nome, g.COR_BRANCO, 22.0, verdadeiro)
		desenhar_texto_com_sombra(x0 + 80, 134, ctrl, cor_texto_fraco, 13.0, falso)

		desenhar_painel(x0 + 262, 110, 108, 30, 170)
		icone_ui(x0 + 268, 113, 4)
		desenhar_texto_com_sombra(x0 + 298, 117, "" + banco, g.COR_AMARELO, 16.0, verdadeiro)

		inteiro nm = 0
		se (mult)
		{
			nm = 1
		}
		desenhar_linha_melhoria(x0 + 37, 168, "Vida extra", 5, n_vida, 5, n_vida * 3, banco, sel == 0, falso)
		desenhar_linha_melhoria(x0 + 37, 246, "Tanque maior", 6, n_comb, 5, n_comb * 3, banco, sel == 1, falso)
		desenhar_linha_melhoria(x0 + 37, 324, "Velocidade máxima", 7, n_vel, 5, n_vel * 3, banco, sel == 2, falso)
		desenhar_linha_melhoria(x0 + 37, 402, "2x estrelas", 8, nm, 1, 15, banco, sel == 3, verdadeiro)
	}

	funcao desenhar_melhorias()
	{
		desenhar_fundo_ui()
		desenhar_divisoria()

		g.definir_tamanho_texto(34.0)
		inteiro lt = g.largura_texto("MELHORIAS")
		icone_ui_g(400 - lt / 2 - 52, 34, 7)
		icone_ui_g(400 + lt / 2 + 14, 34, 7)
		texto_em(400, 36, "MELHORIAS", g.COR_AMARELO, 34.0, verdadeiro)

		desenhar_card_melhorias(0, "Jogador 1", "W/S escolher  |  D comprar", banco_estrelas_p1, opcao_melhoria_p1, nivel_vida_p1, nivel_combustivel_p1, nivel_velocidade_p1, mult_estrelas_p1)
		desenhar_card_melhorias(400, "Jogador 2", "Cima/Baixo escolher  |  Dir comprar", banco_estrelas_p2, opcao_melhoria_p2, nivel_vida_p2, nivel_combustivel_p2, nivel_velocidade_p2, mult_estrelas_p2)

		desenhar_painel(290, 534, 220, 30, 170)
		texto_em(400, 540, "ENTER para voltar", g.COR_VERDE, 17.0, falso)
	}

	funcao desenhar_card_resultado(inteiro x, cadeia nome, inteiro cor_nome, real pontos, inteiro estrelas, inteiro banco, inteiro cps, logico vencedor, logico recorde, real fator)
	{
		se (vencedor)
		{
			g.definir_cor(cor_ouro)
			g.definir_opacidade(90)
			g.desenhar_retangulo(x - 5, 325, 340, 160, verdadeiro, verdadeiro)
			g.definir_opacidade(255)
		}
		desenhar_painel(x, 330, 330, 150, 200)

		g.definir_cor(cor_nome)
		g.desenhar_retangulo(x + 14, 340, 40, 26, verdadeiro, verdadeiro)
		desenhar_texto_com_sombra(x + 22, 343, nome, g.COR_BRANCO, 17.0, falso)
		se (vencedor)
		{
			icone_ui_g(x + 280, 336, 13)
		}
		se (recorde)
		{
			icone_ui(x + 64, 341, 14)
			desenhar_texto_com_sombra(x + 92, 344, "NOVO RECORDE!", cor_ouro, 14.0, verdadeiro)
		}

		desenhar_texto_com_sombra(x + 18, 374, "" + tp.real_para_inteiro(pontos * fator) + " m", g.COR_AMARELO, 36.0, verdadeiro)

		icone_ui(x + 18, 424, 4)
		desenhar_texto_com_sombra(x + 48, 427, "coletadas: " + estrelas + "   |   banco: " + banco, g.COR_BRANCO, 14.0, verdadeiro)
		se (modo_ultima_corrida == 1)
		{
			icone_ui(x + 18, 450, 11)
			desenhar_texto_com_sombra(x + 48, 453, "checkpoints: " + cps, g.COR_BRANCO, 14.0, verdadeiro)
		}
	}

	funcao desenhar_game_over()
	{
		inteiro ms = u.tempo_decorrido() - t_estado_ms

		g.desenhar_imagem(0, 0, img_go_bg)

		// fumaça subindo do carro batido
		para (inteiro i = 0; i < 5; i++)
		{
			inteiro ciclo = (tempo_ui * 2 + i * 40) % 200
			g.desenhar_imagem(650 + (i % 3) * 14 - ciclo / 8, 470 - ciclo, img_fumaca)
		}

		// título com brilho pulsante
		inteiro pulso = (tempo_ui / 6) % 10
		se (pulso > 5)
		{
			pulso = 10 - pulso
		}
		g.definir_opacidade(60 + pulso * 12)
		texto_em(400 - 3, 28, "GAME OVER", g.COR_VERMELHO, 54.0, falso)
		texto_em(400 + 3, 28, "GAME OVER", g.COR_VERMELHO, 54.0, falso)
		texto_em(400, 25, "GAME OVER", g.COR_VERMELHO, 54.0, falso)
		texto_em(400, 31, "GAME OVER", g.COR_VERMELHO, 54.0, falso)
		g.definir_opacidade(255)
		texto_em(400, 28, "GAME OVER", g.COR_BRANCO, 54.0, verdadeiro)

		// vencedor
		cadeia vencedor = "EMPATE!"
		inteiro venc = 0
		se (pontuacao_p1 > pontuacao_p2)
		{
			vencedor = "JOGADOR 1 VENCEU!"
			venc = 1
		}
		senao se (pontuacao_p2 > pontuacao_p1)
		{
			vencedor = "JOGADOR 2 VENCEU!"
			venc = 2
		}
		inteiro balanco = (tempo_ui / 8) % 6
		se (balanco > 3)
		{
			balanco = 6 - balanco
		}
		g.desenhar_imagem(330, 94 + balanco, img_trofeu)
		texto_em(400, 274, vencedor, cor_ouro, 28.0, verdadeiro)

		// números contando para cima
		real fator = ms / 1400.0
		se (fator > 1.0)
		{
			fator = 1.0
		}
		desenhar_card_resultado(50, "P1", cor_azul_p1, pontuacao_p1, estrelas_p1_qtd, banco_estrelas_p1, cp_count[0], venc == 1, novo_recorde_p1, fator)
		desenhar_card_resultado(420, "P2", cor_laranja_p2, pontuacao_p2, estrelas_p2_qtd, banco_estrelas_p2, cp_count[1], venc == 2, novo_recorde_p2, fator)

		se ((tempo_ui / 30) % 2 == 0)
		{
			desenhar_painel(240, 520, 320, 34, 190)
			texto_em(400, 527, "ENTER - voltar ao menu", g.COR_VERDE, 19.0, verdadeiro)
		}

		// entrada suave
		inteiro fade = 255 - ms / 2
		se (fade > 0)
		{
			g.definir_cor(g.COR_PRETO)
			g.definir_opacidade(fade)
			g.desenhar_retangulo(0, 0, LARGURA, ALTURA, falso, verdadeiro)
			g.definir_opacidade(255)
		}
	}

}
