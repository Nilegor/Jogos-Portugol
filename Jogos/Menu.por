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
	inteiro pontuacao_y, pontuacao1_x, pontuacao2_x, pontuacao_img = -1, imagem_pausa=0, portugol=-1
	inteiro tempo_anterior_demo
	logico DEMO_mode = falso
	inteiro player1[6], player2[6], bolinha[8], passo=1, max_vel=7
	inteiro velocidade_player = 8 
	inteiro colision_music, colision_play
	logico pausado = falso
	inteiro forca1 = 0
	inteiro forca2 = 0
	logico carregando1 = falso
	logico carregando2 = falso
	const inteiro FORCA_MAX = 10
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
		g.definir_dimensoes_janela(785, 1024)
		g.definir_titulo_janela("Menu de Opções")

		// Carrega as imagens do menu e dos botões
		imagem_fundo = g.carregar_imagem("Menu/Fundo.png")
		img_corrida = g.carregar_imagem("Menu/Corrida.png")
		img_pong = g.carregar_imagem("Menu/Pong.png")
		img_serpente = g.carregar_imagem("Menu/Serpente.png")
		img_sair = g.carregar_imagem("Menu/Sair.png")

		g.redimensionar_imagem(img_corrida, 535, 120, falso)
		g.redimensionar_imagem(img_pong, 535, 120, falso)
		g.redimensionar_imagem(img_serpente, 535, 120, falso)
		g.redimensionar_imagem(img_sair, 535, 120, falso)

		logico executando = verdadeiro

		enquanto (executando)
		{
			g.desenhar_imagem(0, 0, imagem_fundo)

			// Desenho dos botões do menu
			g.desenhar_imagem(89, 130, img_corrida)
			g.desenhar_imagem(89, 310, img_pong)
			g.desenhar_imagem(14, 435, img_serpente)
			g.desenhar_imagem(89, 670, img_sair)

			// --- BOTÃO DE INFORMAÇÕES (Canto Inferior Direito) ---
			g.definir_opacidade(80)
			g.definir_cor(g.COR_PRETO)
			g.desenhar_retangulo(643, 933, 110, 50, verdadeiro, verdadeiro)

			g.definir_opacidade(200)
			g.definir_cor(g.COR_PRETO)
			g.desenhar_retangulo(640, 930, 110, 50, verdadeiro, verdadeiro)

			g.definir_opacidade(255)
			g.definir_cor(g.COR_AMARELO)
			g.desenhar_retangulo(640, 930, 110, 50, verdadeiro, falso)

			g.definir_cor(g.COR_AMARELO)
			g.desenhar_elipse(655, 942, 26, 26, verdadeiro)
			g.definir_cor(g.COR_PRETO)
			g.definir_tamanho_texto(18.0)
			g.desenhar_texto(666, 946, "i")

			g.definir_cor(g.COR_BRANCO)
			g.definir_tamanho_texto(16.0)
			g.desenhar_texto(690, 946, "INFO")

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
					senao se (mouse_x >= 14 e mouse_x <= 549 e mouse_y >= 640 e mouse_y <= 700)
					{
						executar_jogo_serpente()
						g.definir_dimensoes_janela(785, 1024)
						g.definir_titulo_janela("Menu de Opções")
					}
					senao se (mouse_x >= 89 e mouse_x <= 624 e mouse_y >= 840 e mouse_y <= 1000)
					{
						executando = falso
					}
					senao se (mouse_x >= 640 e mouse_x <= 750 e mouse_y >= 930 e mouse_y <= 980)
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
g.desenhar_retangulo(40, 100, 705, 820, verdadeiro, verdadeiro)

g.definir_opacidade(255)
g.definir_cor(g.COR_AMARELO)
g.desenhar_retangulo(40, 100, 705, 820, verdadeiro, falso)

g.definir_tamanho_texto(22.0)
g.definir_cor(g.COR_AMARELO)
g.desenhar_texto(270, 120, "CENTRAL DE JOGOS - v1.0")

g.definir_tamanho_texto(13.0)
g.definir_cor(g.COR_BRANCO)
g.desenhar_texto(80, 200, "Desenvolvido por: Jackson C. Giordani e Lucas E. V. Bôas")
g.desenhar_texto(80, 220, "Curso Técnico em Desenvolvimento de Sistemas (Matutino) - 2025")

g.definir_tamanho_texto(15.0)

g.definir_cor(g.COR_AMARELO)
g.desenhar_texto(80, 260, "CORRIDA:")
g.definir_cor(g.COR_BRANCO)
g.definir_tamanho_texto(13.0)
g.desenhar_texto(80, 285, "Corrida para dois jogadores (P1: WASD, P2: Setas). Cada um ocupa uma")
g.desenhar_texto(80, 305, "faixa da pista, devendo desviar de veículos, coletar estrelas (para")
g.desenhar_texto(80, 325, "comprar skins e melhorias) e galões de combustível para não parar.")
g.desenhar_texto(80, 345, "Gerencie velocidade e combustível; quanto mais longe, maior a pontuação.")

g.definir_tamanho_texto(15.0)
g.definir_cor(g.COR_AMARELO)
g.desenhar_texto(80, 385, "PONG:")
g.definir_cor(g.COR_BRANCO)
g.definir_tamanho_texto(13.0)
g.desenhar_texto(80, 410, "Beisebol Pong: versão tática do clássico. P1: W/S e Espaço (força);")
g.desenhar_texto(80, 430, "P2: Setas e Enter. A força da rebatida depende do tempo pressionado.")
g.desenhar_texto(80, 450, "Compre melhorias (rebatida aleatória, velocidade, confusão, congelamento)")
g.desenhar_texto(80, 470, "e ative-as durante o jogo para virar a partida.")

g.definir_tamanho_texto(15.0)
g.definir_cor(g.COR_AMARELO)
g.desenhar_texto(80, 510, "SERPENTE:")
g.definir_cor(g.COR_BRANCO)
g.definir_tamanho_texto(13.0)
g.desenhar_texto(80, 535, "Clássico jogo da cobra com elementos elementares. Colete comidas para")
g.desenhar_texto(80, 555, "crescer e acumular pontos. A cada 3 comidas, surge uma fruta especial")
g.desenhar_texto(80, 575, "(Fogo, Gelo, Pedra, Raio ou Vento) com efeitos temporários. Oferece")
g.desenhar_texto(80, 595, "6 níveis de dificuldade, cenário circular e placar de recordes.")
g.desenhar_texto(80, 615, "Use as setas para controlar a direção da serpente.")

g.definir_tamanho_texto(15.0)
g.definir_cor(g.COR_AMARELO)
g.desenhar_texto(80, 655, "SAIR:")
g.definir_cor(g.COR_BRANCO)
g.definir_tamanho_texto(13.0)
g.desenhar_texto(80, 680, "Fecha todos os jogos e encerra o programa.")

g.definir_tamanho_texto(13.0)
g.desenhar_texto(80, 720, "Este menu centraliza todos os jogos desenvolvidos. Basta clicar no")
g.desenhar_texto(80, 740, "botão desejado para iniciar. Cada jogo possui regras e mecânicas próprias.")

g.definir_tamanho_texto(14.0)
g.definir_cor(g.COR_VERDE)
g.desenhar_texto(80, 780, "DICA: Pressione [ESC] para sair de qualquer jogo.")

g.definir_tamanho_texto(14.0)
g.definir_cor(g.COR_AZUL)
g.desenhar_texto(270, 870, "[ Clique fora desta caixa para fechar ]")
			}

			g.renderizar()
		}

		g.liberar_imagem(imagem_fundo)
		g.liberar_imagem(img_corrida)
		g.liberar_imagem(img_pong)
		g.liberar_imagem(img_serpente)
		g.liberar_imagem(img_sair)
		
		g.encerrar_modo_grafico()
	}
		

		
	funcao executar_jogo_serpente()
	{
		g.definir_cor(g.COR_PRETO)
		g.limpar()
		
		g.definir_cor(g.COR_VERDE)
		g.desenhar_texto(300, 280, "Iniciando Jogo da Serpente...")
		g.renderizar()
		
		u.aguarde(2000)
		iniciar_serpente()
	}

	/* Constantes que definem os atributos de um segmento da serpente */	
	const inteiro LINHA = 0, COLUNA = 1, DIRECAO = 2

	/* Constantes que definem as direções possíveis para o segmento da serpente */
	const inteiro ACIMA = 0, ABAIXO = 1, ESQUERDA = 2, DIREITA = 3

	/* Constantes que definem as telas do jogo */
	const inteiro SAIR = 0, MENU = 1, JOGO = 2, VITORIA = 3, DERROTA = 4, PLACAR = 5, IDENTIFICACAO = 6

	/* Constantes que definem as opções do menu */
	const inteiro OPCAO_NOVO_JOGO = 0, OPCAO_DIFICULDADE = 1, OPCAO_CENARIO = 2, OPCAO_SONS = 3, OPCAO_TEMA = 4

	/* Constantes que definem o intervalo de atualização para cada nível de dificuldade */
	const inteiro MUITO_FACIL = 0, FACIL = 1, MEDIO = 2, DIFICIL = 3, MUITO_DIFICIL = 4, CHUCK_NORRIS = 5
	
	/* Intervalos de tempo em que o jogo deve ser atualizado */
	const inteiro INTERVALO_ATUALIZACAO[] = {500, 125, 60, 30, 15, 15}

	/* Valor da comida, de acordo com o nível de dificuldade */
	const inteiro VALOR_COMIDA[] = {1, 5, 25, 50, 75, 125}

	/* Constantes que definem as propriedades do tema do jogo */
	const inteiro NOME_TEMA = 0, PASTA_IMAGENS = 1, COR_FUNDO = 2, COR_TEXTO = 3, COR_BORDA = 4
	
	/* Temas disponíveis para o jogo */
	cadeia TEMAS[][] = 
	{
		{"Moderno", "moderno", "0xB5D3E0", "0x000000", "0x000000"},
		{"Nokia",   "nokia",   "0xB5D3E0", "0x000000", "0x000000"}
	}

	/* Constantes que definem os campos do placar */
	const inteiro NOME_JOGADOR = 0, TEMPO = 1, DIFICULDADE = 2, PONTUACAO = 3
	
	/* Matriz que armazena as entradas do placar */
	cadeia placar_jogo[10][4]

	/* Constantes que definem as dimensões do cenário */
	const inteiro LINHAS = 30, COLUNAS = 35, BORDA_CENARIO = 10, ALTURA_PAINEL_PONTUACAO = 30

	/* Constantes que definem o tamanho da serpente no jogo */
	const inteiro TAMANHO_MAXIMO_SERPENTE = 500, TAMANHO_INICIAL_SERPENTE = 4

	inteiro serpente[TAMANHO_MAXIMO_SERPENTE][3]

	/* Variáveis que definem o índice da cabeça e da cauda da serpente */
	inteiro CABECA = 0, CAUDA = 0 

	/* Variáveis que armazenam as opções do jogo */
	logico cenario_circular = falso, reproduzir_sons = verdadeiro, continuar = falso
	
	inteiro dificuldade = MEDIO, tema_atual = 0, opcao_menu_serpente = OPCAO_NOVO_JOGO

	/* Variáveis de controle do jogo */
	cadeia nome_jogador = ""
	
	inteiro pontuacao_jogador = 0, tamanho_serpente = 0, entrada_placar = -1
	inteiro altura_tela = 0, largura_tela = 0, tamanho_segmento = 0
	logico primeira_execucao = verdadeiro, pode_continuar = falso, exibir_intermitencia = falso
	
	inteiro comida[2], ultimo_estado_cauda[3], tema[5]

	/* --- MECÂNICAS ELEMENTARES --- */
	const inteiro FRUTA_FOGO = 0, FRUTA_GELO = 1, FRUTA_PEDRA = 2, FRUTA_RAIO = 3, FRUTA_VENTO = 4

	logico fruta_especial_ativa = falso
	inteiro fruta_especial[2]
	inteiro tipo_fruta_especial = 0
	inteiro contador_comidas_normais = 0
	inteiro tempo_spawn_fruta = 0

	/* Controle dos Efeitos Ativos */
	inteiro efeito_ativo = -1 
	inteiro duracao_efeito = 0

	/* Variáveis de fluxo das telas */
	inteiro tela_atual = MENU, tela_anterior = SAIR	

	/* Controle de tempo e quadros */
	inteiro tempo_inicio_frame, tempo_decorrido_frame, tempo_restante_frame
	inteiro tempo_total_jogo = 0, tempo_inicio_jogo = 0, tempo_inicio_intermitencia = 0

	/* Recursos visuais e sonoros */
	inteiro imagem_segmento = 0, imagem_comida = 0
	inteiro imagens_frutas_especiais[5]

	inteiro musica_menu_serpente = -1, musica_jogo_serpente = -1, som_comida = -1, som_derrota = -1
	inteiro rep_musica_menu = -1, rep_musica_jogo = -1
	
	funcao iniciar_serpente()
	{
		inicializar_serpente()
		
		enquanto (tela_atual != SAIR)
		{	
			escolha (tela_atual)
			{
				caso JOGO           : tela_jogo()          pare
				caso VITORIA        : tela_vitoria()       pare
				caso MENU           : tela_menu()          pare
				caso DERROTA        : tela_derrota()       pare
				caso PLACAR         : tela_placar()        pare
				caso IDENTIFICACAO  : tela_identificacao() pare
			}
		}
		
		finalizar_serpente()
	}

	funcao inicializar_serpente()
	{
		g.iniciar_modo_grafico(verdadeiro)
		g.definir_titulo_janela("Serpente Elementar")

		definir_tema(tema_atual)
		carregar_sons_serpente()
		carregar_placar()
		carregar_fontes()
		carregar_jogo_salvo()
	}

	funcao carregar_sons_serpente()
	{
		cadeia diretorio_sons = "./serpente/sons/"

		musica_menu = sm.carregar_som(diretorio_sons + "musica_menu.mp3")
		musica_jogo_serpente = sm.carregar_som(diretorio_sons + "musica_jogo.mp3")
		som_comida  = sm.carregar_som(diretorio_sons + "som_comida.mp3" )
		som_derrota = sm.carregar_som(diretorio_sons + "som_derrota.mp3")
	}

	funcao definir_tema(inteiro indice)
	{
		tema_atual = indice
		
		tema[COR_FUNDO] = tp.cadeia_para_inteiro(TEMAS[tema_atual][COR_FUNDO], 16)
		tema[COR_TEXTO] = tp.cadeia_para_inteiro(TEMAS[tema_atual][COR_TEXTO], 16)
		tema[COR_BORDA] = tp.cadeia_para_inteiro(TEMAS[tema_atual][COR_BORDA], 16)	
		
		se (nao primeira_execucao)
		{
			liberar_imagens()
		}
		senao
		{
			primeira_execucao = falso
		}
		
		carregar_imagens_serpente()
		atualizar_dimensoes_janela()
	}

	funcao carregar_imagens_serpente()
	{
		cadeia diretorio_temas = "./serpente/temas/"
		cadeia diretorio_imagens = diretorio_temas + TEMAS[tema_atual][PASTA_IMAGENS] + "/"
		
		imagem_segmento = g.carregar_imagem(diretorio_imagens + "segmento.png")
		imagem_comida = g.carregar_imagem(diretorio_imagens + "comida.png")

		imagens_frutas_especiais[FRUTA_FOGO]  = g.carregar_imagem(diretorio_imagens + "fruta_fogo.png")
		imagens_frutas_especiais[FRUTA_GELO]  = g.carregar_imagem(diretorio_imagens + "fruta_gelo.png")
		imagens_frutas_especiais[FRUTA_PEDRA] = g.carregar_imagem(diretorio_imagens + "fruta_pedra.png")
		imagens_frutas_especiais[FRUTA_RAIO]  = g.carregar_imagem(diretorio_imagens + "fruta_raio.png")
		imagens_frutas_especiais[FRUTA_VENTO] = g.carregar_imagem(diretorio_imagens + "fruta_vento.png")
	}

	funcao carregar_fontes()
	{
		g.carregar_fonte("Outros/fontes/poetsen_one_regular.ttf")
		g.definir_fonte_texto("Poetsen One")
	}

	funcao atualizar_dimensoes_janela()
	{
		tamanho_segmento = g.altura_imagem(imagem_segmento)
		
		altura_tela = ALTURA_PAINEL_PONTUACAO + (LINHAS * tamanho_segmento) + (BORDA_CENARIO * 2) + 3
		largura_tela = (COLUNAS * tamanho_segmento) + (BORDA_CENARIO * 2) + 3
		
		g.definir_dimensoes_janela(largura_tela, altura_tela)
	}

	funcao atualizar_placar()
	{
		se (jogador_entra_placar())
		{
			inserir_jogador_placar()
			ordenar_placar()
			salvar_placar()
		}
		senao
		{
			entrada_placar = -1
		}
	}

	funcao inserir_jogador_placar()
	{
		inteiro ultima_linha = u.numero_linhas(placar_jogo) - 1
		
		placar_jogo[ultima_linha][NOME_JOGADOR] = nome_jogador
		placar_jogo[ultima_linha][PONTUACAO] = tp.inteiro_para_cadeia(pontuacao_jogador, 10)
		placar_jogo[ultima_linha][DIFICULDADE] = tp.inteiro_para_cadeia(dificuldade, 10)
		placar_jogo[ultima_linha][TEMPO] = tp.inteiro_para_cadeia(tempo_total_jogo, 10)

		entrada_placar = u.numero_linhas(placar_jogo) - 1		
	}

	funcao logico jogador_entra_placar()
	{
		se (placar_possui_posicao_livre())
		{
			retorne verdadeiro
		}
		senao
		{
			inteiro ultima_linha = u.numero_linhas(placar_jogo) - 1

			se (placar_jogo[ultima_linha][NOME_JOGADOR] != "-")
			{
				inteiro pontuacao_ultimo = tp.cadeia_para_inteiro(placar_jogo[ultima_linha][PONTUACAO], 10)
				inteiro dificuldade_ultimo = tp.cadeia_para_inteiro(placar_jogo[ultima_linha][DIFICULDADE], 10)		
				inteiro tempo_ultimo = tp.cadeia_para_inteiro(placar_jogo[ultima_linha][TEMPO], 10)		
	
				inteiro comparacao = pontuacao_jogador - pontuacao_ultimo
	
				se (comparacao == 0)
				{
					comparacao = dificuldade - dificuldade_ultimo 
				}
	
				se (comparacao == 0)
				{
					comparacao = tempo_ultimo - tempo_total_jogo
				}

				se (comparacao > 0)
				{
					retorne verdadeiro
				}
				senao				
				{
					retorne falso
				}				
			}
			senao 
			{
				retorne verdadeiro
			}
		}
	}

	funcao logico placar_possui_posicao_livre()
	{	
		para (inteiro i = 0; i < u.numero_linhas(placar_jogo); i++)
		{
			se (placar_jogo[i][NOME_JOGADOR] == "-")
			{
				retorne verdadeiro
			}
		}
		
		retorne falso
	}

	funcao inteiro comparar_posicoes_placar(inteiro posicao_1, inteiro posicao_2)
	{
		se (placar_jogo[posicao_1][NOME_JOGADOR] == "-")
		{
			retorne -1
		}
		se (placar_jogo[posicao_2][NOME_JOGADOR] == "-")
		{
			retorne 1
		}		
		
		inteiro resultado = 0
		
		inteiro pontuacao_1 = tp.cadeia_para_inteiro(placar_jogo[posicao_1][PONTUACAO], 10)
		inteiro pontuacao_2 = tp.cadeia_para_inteiro(placar_jogo[posicao_2][PONTUACAO], 10)

		resultado = pontuacao_1 - pontuacao_2
		
		se (resultado == 0)
		{
			inteiro dificuldade_1 = tp.cadeia_para_inteiro(placar_jogo[posicao_1][DIFICULDADE], 10)
			inteiro dificuldade_2 = tp.cadeia_para_inteiro(placar_jogo[posicao_2][DIFICULDADE], 10)

			resultado = dificuldade_1 - dificuldade_2
		}

		se (resultado == 0)
		{
			inteiro tempo_1 = tp.cadeia_para_inteiro(placar_jogo[posicao_1][TEMPO], 10)
			inteiro tempo_2 = tp.cadeia_para_inteiro(placar_jogo[posicao_2][TEMPO], 10)
			
			resultado = tempo_2 - tempo_1
		}

		retorne resultado
	}

	funcao trocar_posicao_placar(inteiro posicao_1, inteiro posicao_2)
	{
		cadeia aux[4]

		aux[NOME_JOGADOR] = placar_jogo[posicao_1][NOME_JOGADOR]
		aux[PONTUACAO] = placar_jogo[posicao_1][PONTUACAO]
		aux[DIFICULDADE] = placar_jogo[posicao_1][DIFICULDADE]
		aux[TEMPO] = placar_jogo[posicao_1][TEMPO]

		placar_jogo[posicao_1][NOME_JOGADOR] = placar_jogo[posicao_2][NOME_JOGADOR]
		placar_jogo[posicao_1][PONTUACAO] = placar_jogo[posicao_2][PONTUACAO]
		placar_jogo[posicao_1][DIFICULDADE] = placar_jogo[posicao_2][DIFICULDADE]
		placar_jogo[posicao_1][TEMPO] = placar_jogo[posicao_2][TEMPO]
		
		placar_jogo[posicao_2][NOME_JOGADOR] = aux[NOME_JOGADOR]
		placar_jogo[posicao_2][PONTUACAO] = aux[PONTUACAO]
		placar_jogo[posicao_2][DIFICULDADE] = aux[DIFICULDADE]
		placar_jogo[posicao_2][TEMPO] = aux[TEMPO]

		se (posicao_1 == entrada_placar)
		{
			entrada_placar = posicao_2
		}
		senao se (posicao_2 == entrada_placar)
		{
			entrada_placar = posicao_1
		}		
	}

	funcao ordenar_placar()
	{
		para (inteiro i = 0; i < u.numero_linhas(placar_jogo); i++)
		{
			para (inteiro j = 0; j < u.numero_linhas(placar_jogo) - 1; j++)
			{
				inteiro comparacao = comparar_posicoes_placar(j, j + 1)

				se (comparacao < 0)
				{
					trocar_posicao_placar(j, j + 1)
				}
			}
		}
	}

	funcao salvar_placar()
	{
		cadeia linha, campo_nome, campo_pontuacao, campo_tempo, campo_dificuldade
		
		cadeia diretorio_jogo = u.obter_diretorio_usuario() + "/.portugol/dados/serpente/"
		cadeia caminho_arquivo = diretorio_jogo + "placar.txt"
		inteiro arquivo_placar = arq.abrir_arquivo(caminho_arquivo, arq.MODO_ESCRITA)

		para (inteiro i = 0; i < u.numero_linhas(placar_jogo); i++)
		{
			campo_nome = placar_jogo[i][NOME_JOGADOR]
			campo_pontuacao = placar_jogo[i][PONTUACAO]
			campo_tempo = placar_jogo[i][TEMPO]
			campo_dificuldade = placar_jogo[i][DIFICULDADE]
			
			linha = campo_nome + ";" + campo_tempo + ";" + campo_dificuldade + ";" + campo_pontuacao + ";"
			arq.escrever_linha(linha, arquivo_placar)
		}

		arq.fechar_arquivo(arquivo_placar)
	}

	funcao carregar_placar()
	{
		cadeia linha
		cadeia diretorio_jogo = u.obter_diretorio_usuario() + "/.portugol/dados/serpente/"
		cadeia caminho_arquivo = diretorio_jogo + "placar.txt"

		se (arq.arquivo_existe(caminho_arquivo))
		{
			inteiro arquivo_placar = arq.abrir_arquivo(caminho_arquivo, arq.MODO_LEITURA)		
			
			para (inteiro i = 0; i < u.numero_linhas(placar_jogo); i++)
			{
				linha = arq.ler_linha(arquivo_placar)
	
				placar_jogo[i][NOME_JOGADOR]	= ler_proximo_campo(linha)
				placar_jogo[i][TEMPO] 		= ler_proximo_campo(linha)
				placar_jogo[i][DIFICULDADE] 	= ler_proximo_campo(linha)
				placar_jogo[i][PONTUACAO] 	= ler_proximo_campo(linha)
			}
	
			arq.fechar_arquivo(arquivo_placar)
		}
		senao
		{
			zerar_placar()
		}
	}

	funcao cadeia ler_proximo_campo(cadeia &linha_placar)
	{
		inteiro posicao_final = txt.posicao_texto(";", linha_placar, 0)
		cadeia nome = txt.extrair_subtexto(linha_placar, 0, posicao_final)

		linha_placar = txt.extrair_subtexto(linha_placar, posicao_final + 1, txt.numero_caracteres(linha_placar))

		retorne nome
	}

	funcao tela_placar()
	{
		enquanto (tela_atual == PLACAR)
		{
			atualizar_intermitencia(250)
			desenhar_tela_placar()

			se (t.tecla_pressionada(t.TECLA_ESC))
			{
				ir_para_a_tela(MENU)
			}
			senao se (t.tecla_pressionada(t.TECLA_DELETAR))
			{
				zerar_placar()
			}
			senao se (t.tecla_pressionada(t.TECLA_ENTER))
			{
				se (tela_anterior == DERROTA ou tela_anterior == VITORIA)
				{
					ir_para_a_tela(JOGO)
				}
				senao
				{
					ir_para_a_tela(MENU)
				}
			}
		}

		entrada_placar = -1
		u.aguarde(200)
	}

	funcao zerar_placar()
	{
		para (inteiro i = 0; i < u.numero_linhas(placar_jogo); i++)
		{
			placar_jogo[i][NOME_JOGADOR] = "-"
			placar_jogo[i][PONTUACAO] = "-"
			placar_jogo[i][DIFICULDADE] = "-"			
			placar_jogo[i][TEMPO] = "-"
		}

		entrada_placar = -1
		salvar_placar()
	}

	funcao carregar_jogo_salvo()
	{
		cadeia linha
		cadeia diretorio_jogo = u.obter_diretorio_usuario() + "/.portugol/dados/serpente/"
		cadeia caminho_arquivo = diretorio_jogo + "continue.txt"
		
		se (arq.arquivo_existe(caminho_arquivo))
		{
			inteiro arquivo_continue = arq.abrir_arquivo(caminho_arquivo, arq.MODO_LEITURA)
			
			linha = arq.ler_linha(arquivo_continue)
			nome_jogador = ler_proximo_campo(linha)
	
			cadeia campo_pontuacao = ler_proximo_campo(linha)
			cadeia campo_dificuldade = ler_proximo_campo(linha)
			cadeia campo_tempo = ler_proximo_campo(linha)
			cadeia campo_cenario = ler_proximo_campo(linha)
			cadeia campo_sons = ler_proximo_campo(linha)
			cadeia campo_tema = ler_proximo_campo(linha)
	
			pontuacao_jogador = tp.cadeia_para_inteiro(campo_pontuacao, 10)
			dificuldade = tp.cadeia_para_inteiro(campo_dificuldade, 10)
			tempo_total_jogo = tp.cadeia_para_inteiro(campo_tempo, 10)
			cenario_circular = tp.cadeia_para_logico(campo_cenario)
			reproduzir_sons = tp.cadeia_para_logico(campo_sons)
			tema_atual = tp.cadeia_para_inteiro(campo_tema, 10)
	
			linha = arq.ler_linha(arquivo_continue)
	
			cadeia campo_linha = ler_proximo_campo(linha)
			cadeia campo_coluna = ler_proximo_campo(linha)

			comida[LINHA] = tp.cadeia_para_inteiro(campo_linha, 10)
			comida[COLUNA] = tp.cadeia_para_inteiro(campo_coluna, 10)
			
			linha = arq.ler_linha(arquivo_continue)
			cadeia campo_numero_segmentos = ler_proximo_campo(linha)
	
			tamanho_serpente = tp.cadeia_para_inteiro(campo_numero_segmentos, 10)
			CAUDA = tamanho_serpente - 1
	
			para (inteiro SEGMENTO = CABECA; SEGMENTO <= CAUDA; SEGMENTO++)
			{
				linha = arq.ler_linha(arquivo_continue)
				
				cadeia linha_serpente = ler_proximo_campo(linha)
				cadeia coluna_serpente = ler_proximo_campo(linha)
				cadeia direcao_serpente = ler_proximo_campo(linha)
	
				serpente[SEGMENTO][LINHA] = tp.cadeia_para_inteiro(linha_serpente, 10)
				serpente[SEGMENTO][COLUNA] = tp.cadeia_para_inteiro(coluna_serpente, 10)
				serpente[SEGMENTO][DIRECAO] = tp.cadeia_para_inteiro(direcao_serpente, 10)
			}
			
			arq.fechar_arquivo(arquivo_continue)
			
			habilitar_continuacao_jogo()
			definir_tema(tema_atual)
			ir_para_a_tela(MENU)
		}
		senao
		{
			recomecar()
		}
	}

	funcao salvar_jogo()
	{
		cadeia diretorio_jogo = u.obter_diretorio_usuario() + "/.portugol/dados/serpente/"
		cadeia caminho_arquivo = diretorio_jogo + "continue.txt"
		inteiro arquivo_continue = arq.abrir_arquivo(caminho_arquivo, arq.MODO_ESCRITA)

		cadeia campo_nome = nome_jogador
		cadeia campo_pontuacao = tp.inteiro_para_cadeia(pontuacao_jogador, 10)
		cadeia campo_dificuldade = tp.inteiro_para_cadeia(dificuldade, 10)
		cadeia campo_tempo = tp.inteiro_para_cadeia(tempo_total_jogo, 10)
		cadeia campo_cenario = tp.logico_para_cadeia(cenario_circular)
		cadeia campo_sons = tp.logico_para_cadeia(reproduzir_sons)
		cadeia campo_tema = tp.inteiro_para_cadeia(tema_atual, 10)		
		
		cadeia linha = campo_nome +  ";" + campo_pontuacao + ";" + campo_dificuldade + ";" + 
					campo_tempo + ";" + campo_cenario + ";" + campo_sons + ";" + campo_tema + ";"

		arq.escrever_linha(linha, arquivo_continue)
		
		cadeia linha_comida = tp.inteiro_para_cadeia(comida[LINHA], 10)
		cadeia coluna_comida = tp.inteiro_para_cadeia(comida[COLUNA], 10)
		cadeia numero_segmentos = tp.inteiro_para_cadeia(tamanho_serpente, 10)

		linha = linha_comida + ";" + coluna_comida + ";"		
		arq.escrever_linha(linha, arquivo_continue)

		linha = numero_segmentos + ";"
		arq.escrever_linha(linha, arquivo_continue)

		para (inteiro SEGMENTO = CABECA; SEGMENTO <= CAUDA; SEGMENTO++)
		{
			cadeia linha_serpente = tp.inteiro_para_cadeia(serpente[SEGMENTO][LINHA], 10)
			cadeia coluna_serpente = tp.inteiro_para_cadeia(serpente[SEGMENTO][COLUNA], 10)
			cadeia direcao_serpente = tp.inteiro_para_cadeia(serpente[SEGMENTO][DIRECAO], 10)

			linha = linha_serpente + ";" + coluna_serpente + ";" + direcao_serpente + ";"
			arq.escrever_linha(linha, arquivo_continue)
		}
		
		arq.fechar_arquivo(arquivo_continue)
	}

	funcao apagar_arquivo_continue()
	{
		cadeia diretorio_jogo = u.obter_diretorio_usuario() + "/.portugol/dados/serpente/"
		cadeia caminho_arquivo = diretorio_jogo + "continue.txt"

		se (arq.arquivo_existe(caminho_arquivo))
		{
			arq.apagar_arquivo(caminho_arquivo)
		}
	}
	
	funcao tela_identificacao()
	{
		enquanto (tela_atual == IDENTIFICACAO)
		{
			desenhar_tela_identificacao()

			inteiro tecla = t.ler_tecla()
			
			se (tecla == t.TECLA_ENTER)
			{
				se (identificacao_valida())
				{
					ir_para_a_tela(JOGO)
				}
			}
			senao se (tecla == t.TECLA_ESC)
			{
				ir_para_a_tela(MENU)
			}
			senao se ((tecla >= t.TECLA_A e tecla <= t.TECLA_Z) ou tecla == t.TECLA_ESPACO ou tecla == t.TECLA_BACKSPACE)
			{
				atualizar_nome_jogador(tecla)
			}
		}
	}

	funcao logico identificacao_valida()
	{
		cadeia texto = txt.substituir(nome_jogador, " ", "")
		retorne (txt.numero_caracteres(texto) > 0)
	}

	funcao desenhar_tela_identificacao()
	{
		desenhar_fundo_cenario()
		desenhar_campo_entrada_nome()
		desenhar_borda_cenario()
		g.renderizar()
	}

	funcao desenhar_campo_entrada_nome()
	{
		g.definir_tamanho_texto(14.0)
		g.definir_cor(tema[COR_TEXTO])
		g.definir_estilo_texto(falso, falso, falso)

		cadeia mensagem = "Digite seu nome: "
		cadeia texto = "WWWWWWWWWWWWWWWWWWWWWWWWW_"
		
		inteiro espacamento = 10
		inteiro margem_campo = 8
		inteiro largura_campo = g.largura_texto(texto) + (margem_campo * 2)
		inteiro altura_campo = g.altura_texto(texto) + (margem_campo * 2)
		inteiro altura_mensagem = g.altura_texto(mensagem)		

		inteiro borda_vertical = 10
		inteiro borda_horizontal = 10
		inteiro largura_quadro = largura_campo + (borda_horizontal * 2)
		inteiro altura_quadro = altura_mensagem + espacamento + altura_campo + (borda_vertical * 2)
		inteiro x = (largura_tela / 2) - (largura_quadro / 2)
		inteiro y = ((altura_tela + ALTURA_PAINEL_PONTUACAO) / 2) - (altura_quadro / 2)

		g.definir_cor(tema[COR_BORDA])
		g.desenhar_retangulo(x, y, largura_quadro, altura_quadro, falso, falso)

		x = x + borda_horizontal
		y = y + borda_vertical
		
		g.desenhar_texto(x, y, mensagem)
		y = y + g.altura_texto(mensagem) + espacamento
		g.desenhar_retangulo(x, y, largura_campo, altura_campo, falso, falso)
		
		g.desenhar_texto(x + margem_campo, y + margem_campo, nome_jogador + "_")
	}

	funcao atualizar_nome_jogador(inteiro tecla)
	{
		inteiro tamanho = txt.numero_caracteres(nome_jogador)
		
		se (tecla == t.TECLA_BACKSPACE)
		{
			se (tamanho >= 1)
			{			
				nome_jogador = txt.extrair_subtexto(nome_jogador, 0, tamanho - 1)
			}
		}
		senao se (tamanho + 1 <= 25)
		{
			nome_jogador = nome_jogador + t.caracter_tecla(tecla)
		}
	}

	funcao desenhar_tela_placar()
	{
		desenhar_fundo_cenario()
		desenhar_conteudo_placar()
		desenhar_borda_cenario()
		g.renderizar()
	}

	funcao desenhar_conteudo_placar()
	{
		g.definir_tamanho_texto(20.0)
		g.definir_cor(tema[COR_TEXTO])
		g.definir_estilo_texto(falso, falso, falso)
		
		cadeia titulo = "PLACAR"
		
		inteiro borda = 12
		inteiro largura_titulo = g.largura_texto(titulo)
		inteiro x_titulo = (largura_tela / 2) - (largura_titulo / 2)
		inteiro y_titulo = ALTURA_PAINEL_PONTUACAO + BORDA_CENARIO + borda

		g.desenhar_texto(x_titulo, y_titulo, titulo)
		
		inteiro y = y_titulo + g.altura_texto("PLACAR") + borda

		g.definir_tamanho_texto(14.0)
		
		inteiro x_tempo = largura_tela - BORDA_CENARIO - 20 - g.largura_texto("Tempo")
		inteiro x_dificuldade = x_tempo - 20 - g.largura_texto("Dificuldade")
		inteiro x_pontuacao = x_dificuldade - 20 - g.largura_texto("Pontuação")
		inteiro x_posicao = BORDA_CENARIO + 10
		inteiro x_nome = x_posicao + g.largura_texto("Pos.") + 10

		g.definir_cor(tema[COR_BORDA])
		
		g.desenhar_linha(x_posicao, y, x_tempo + g.largura_texto("Tempo") + 10, y)
		y = y + 6		

		g.desenhar_texto(x_posicao, y, "Pos.")
		g.desenhar_texto(x_nome, y, "Nome")
		g.desenhar_texto(x_pontuacao, y, "Pontuação")
		g.desenhar_texto(x_dificuldade, y, "Dificuldade")		
		g.desenhar_texto(x_tempo, y, "Tempo")

		y = y + g.altura_texto("Nome") + 6
		g.desenhar_linha(x_posicao, y, x_tempo + g.largura_texto("Tempo") + 10, y)
		y = y + borda
		
		para (inteiro i = 0; i < u.numero_linhas(placar_jogo); i++)
		{
			cadeia campo_posicao = txt.preencher_a_esquerda('0', 2, tp.inteiro_para_cadeia((i + 1), 10)) + "."
			cadeia campo_nome = texto_nome_placar(i)
			cadeia campo_dificuldade = texto_dificuldade_placar(i)
			cadeia campo_tempo = texto_tempo_placar(i)
			cadeia campo_pontuacao = texto_pontuacao_placar(i)

			g.desenhar_texto(x_posicao, y, campo_posicao)
			g.desenhar_texto(x_nome, y, campo_nome)
			g.desenhar_texto(x_dificuldade, y, campo_dificuldade)
			g.desenhar_texto(x_pontuacao, y, campo_pontuacao)
			g.desenhar_texto(x_tempo, y, campo_tempo)

			se (entrada_placar == i e exibir_intermitencia)
			{
				inteiro largura = x_tempo + g.largura_texto("Tempo") + 14 - x_posicao - 4
				inteiro altura = g.altura_texto(campo_nome) + 8
				
				g.desenhar_retangulo(x_posicao - 4, y - 6, largura, altura, falso, falso)
			}

			y = y + g.altura_texto("Nome") + 15
		}

		inteiro x, largura_mensagem, altura_mensagem
		g.desenhar_linha(x_posicao, y, x_tempo + g.largura_texto("Tempo") + 10, y)

		cadeia mensagem
		inteiro k = altura_tela - BORDA_CENARIO		
		y = k - ((k - y) / 2)

		mensagem = "Pressione [ ENTER ] para continuar"		
		largura_mensagem = g.largura_texto(mensagem)
		altura_mensagem = g.altura_texto(mensagem)
		x = (largura_tela / 2) - (largura_mensagem / 2)
		g.desenhar_texto(x, y - altura_mensagem - 15, mensagem)

		mensagem = "Pressione [ DELETE ] para zerar o placar"
		largura_mensagem = g.largura_texto(mensagem)
		altura_mensagem = g.altura_texto(mensagem)
		x = (largura_tela / 2) - (largura_mensagem / 2)
		g.desenhar_texto(x, y - (altura_mensagem / 2), mensagem)

		mensagem = "Pressione [ ESC ] para voltar ao menu"
		largura_mensagem = g.largura_texto(mensagem)
		altura_mensagem = g.altura_texto(mensagem)
		x = (largura_tela / 2) - (largura_mensagem / 2)
		g.desenhar_texto(x, y + 15, mensagem)
	}

	funcao cadeia texto_pontuacao_placar(inteiro indice)
	{
		cadeia texto = placar_jogo[indice][PONTUACAO]
		se (texto == "-") { texto = "----" }
		retorne texto
	}

	funcao cadeia texto_nome_placar(inteiro indice)
	{
		cadeia texto = placar_jogo[indice][NOME_JOGADOR]
		se (texto == "-") { texto = "-------------------------" }
		retorne texto
	}

	funcao cadeia texto_tempo_placar(inteiro indice)
	{
		cadeia texto = placar_jogo[indice][TEMPO]
		se (texto != "-")
		{
			inteiro tempo = tp.cadeia_para_inteiro(texto, 10)
			texto = formatar_tempo(tempo)
		}
		senao { texto = "--:--" }
		retorne texto
	}

	funcao cadeia texto_dificuldade_placar(inteiro indice)
	{
		cadeia texto = placar_jogo[indice][DIFICULDADE]
		se (texto != "-")
		{
			inteiro dif = tp.cadeia_para_inteiro(texto, 10)
			texto = texto_opcao_dificuldade(dif)
			texto = txt.substituir(texto, "Dificuldade: ", "")
		}
		senao { texto = "------------" }
		retorne texto
	}

	funcao ir_para_a_tela(inteiro nova_tela)
	{
		se (nova_tela != tela_atual)
		{
			tela_anterior = tela_atual
			tela_atual = nova_tela
		}
	}

	funcao tela_vitoria()
	{
		atualizar_placar()
		desabilitar_continuacao_jogo()
		
		enquanto (tela_atual == VITORIA)
		{
			desenhar_tela_vitoria()

			se (t.tecla_pressionada(t.TECLA_ESC)) { ir_para_a_tela(MENU) }
			senao se (t.tecla_pressionada(t.TECLA_ENTER)) { ir_para_a_tela(PLACAR) }
		}

		u.aguarde(200)
	}

	funcao tela_derrota()
	{
		atualizar_placar()
		desabilitar_continuacao_jogo()
		
		enquanto (tela_atual == DERROTA)
		{
			desenhar_tela_derrota()

			se (t.tecla_pressionada(t.TECLA_ESC)) { ir_para_a_tela(MENU) }
			senao se (t.tecla_pressionada(t.TECLA_ENTER)) { ir_para_a_tela(PLACAR) }
		}

		u.aguarde(200)
	}

	funcao desabilitar_continuacao_jogo()
	{
		continuar = falso
		pode_continuar = falso
		apagar_arquivo_continue()
	}

	funcao desenhar_tela_vitoria()
	{
		cadeia itens[] = 
		{
			"Parabéns você venceu o jogo!",
			"Pressione [ ENTER ] para continuar",
			"Pressione [ ESC ] para voltar ao menu"
		}

		desenhar_tela_jogo()
		desenhar_popup(itens, -1)
		g.renderizar()
	}

	funcao desenhar_tela_derrota()
	{		
		cadeia itens[] = 
		{
			"Que pena você perdeu o jogo!",
			"Pressione [ ENTER ] para continuar",
			"Pressione [ ESC ] para voltar ao menu"
		}

		desenhar_tela_jogo()		
		desenhar_popup(itens, -1)
		g.renderizar()
	}

	funcao tela_menu()
	{
		reproduzir_musica_menu()	
		
		enquanto (tela_atual == MENU)
		{
			atualizar_intermitencia(200)
			pausar_contador_tempo()
			desenhar_tela_menu()

			se (t.tecla_pressionada(t.TECLA_ENTER))
			{
				se (continuar)
				{
					ir_para_a_tela(JOGO)
				}
				senao
				{
					ir_para_a_tela(IDENTIFICACAO)
					u.aguarde(200)
				}
			}
			senao se (t.tecla_pressionada(t.TECLA_ESC))
			{
				ir_para_a_tela(SAIR)
			}
			senao se (t.tecla_pressionada(t.TECLA_ESPACO))
			{
				ir_para_a_tela(PLACAR)
			}
			senao se (t.tecla_pressionada(t.TECLA_SETA_ABAIXO) ou t.tecla_pressionada(t.TECLA_SETA_ACIMA))
			{
				selecionar_opcao_menu()
			}
			senao se (t.tecla_pressionada(t.TECLA_SETA_ESQUERDA) ou t.tecla_pressionada(t.TECLA_SETA_DIREITA))
			{
				escolha (opcao_menu_serpente)
				{
					caso OPCAO_NOVO_JOGO	: alternar_opcao_novo_jogo()  pare					
					caso OPCAO_SONS 	 	: alternar_opcao_sons()       pare
					caso OPCAO_CENARIO		: alternar_opcao_cenario()    pare					
					caso OPCAO_DIFICULDADE 	: alternar_opcao_dificuldade()pare
					caso OPCAO_TEMA 		: alternar_opcao_tema()       pare
				}
				u.aguarde(200) 
			}
		}
	}

	funcao atualizar_intermitencia(inteiro intervalo)
	{
		se (u.tempo_decorrido() - tempo_inicio_intermitencia >= intervalo)
		{
			exibir_intermitencia = nao exibir_intermitencia
			tempo_inicio_intermitencia = u.tempo_decorrido()
		}
	}

	funcao selecionar_opcao_menu()
	{
		se (t.tecla_pressionada(t.TECLA_SETA_ACIMA))
		{
			opcao_menu_serpente = (5 + opcao_menu_serpente - 1) % 5
		}
		se (t.tecla_pressionada(t.TECLA_SETA_ABAIXO))
		{
			opcao_menu_serpente = (opcao_menu_serpente + 1) % 5
		}
		u.aguarde(200)
	}

	funcao inteiro alternar_opcao_dificuldade()
	{
		se (t.tecla_pressionada(t.TECLA_SETA_ESQUERDA))
		{
			dificuldade = (6 + dificuldade - 1) % 6
		}
		senao se (t.tecla_pressionada(t.TECLA_SETA_DIREITA))
		{
			dificuldade = (dificuldade + 1) % 6
		}

		se (dificuldade == CHUCK_NORRIS) { cenario_circular = falso }
		desabilitar_continuacao_jogo()
		retorne 0
	}

	funcao inteiro alternar_opcao_tema()
	{
		se (t.tecla_pressionada(t.TECLA_SETA_ESQUERDA))
		{
			tema_atual = (u.numero_linhas(TEMAS) + tema_atual - 1) % u.numero_linhas(TEMAS)
		}
		senao se (t.tecla_pressionada(t.TECLA_SETA_DIREITA))
		{
			tema_atual = (tema_atual + 1) % u.numero_linhas(TEMAS)
		}
		definir_tema(tema_atual)
		retorne 0
	}

	funcao alternar_opcao_cenario()
	{
		se (dificuldade != CHUCK_NORRIS)
		{
			cenario_circular = (nao cenario_circular)
		}
		senao { cenario_circular = falso }
		desabilitar_continuacao_jogo()
	}

	funcao alternar_opcao_novo_jogo()
	{
		se (pode_continuar) { continuar = (nao continuar) }
		senao { continuar = falso }
	}

	funcao alternar_opcao_sons()
	{
		reproduzir_sons = nao reproduzir_sons

		se (reproduzir_sons e rep_musica_menu < 0)
		{
			rep_musica_menu = sm.reproduzir_som(musica_menu, verdadeiro)
		}
		senao se (nao reproduzir_sons e rep_musica_menu >= 0)
		{
			sm.interromper_som(rep_musica_menu)
			rep_musica_menu = -1
		}
	}

	funcao reproduzir_musica_menu()
	{
		se (reproduzir_sons e rep_musica_jogo >= 0)
		{
			sm.interromper_som(rep_musica_jogo)
			rep_musica_jogo = -1
		}

		se (reproduzir_sons e rep_musica_menu < 0)
		{
			rep_musica_menu = sm.reproduzir_som(musica_menu, verdadeiro)
		}
	}

	funcao interromper_musica_menu()
	{
		se (reproduzir_sons)
		{
			sm.interromper_som(rep_musica_menu)
			rep_musica_menu = -1
		}
	}

	funcao pausar_contador_tempo()
	{
		tempo_inicio_jogo = u.tempo_decorrido() - tempo_total_jogo
	}

	funcao desenhar_tela_menu()
	{
		cadeia itens[] =  
		{
			"Bem vindo ao jogo da serpente",
			"================================",
			" ",
			" ",
			texto_opcao_continuar(),			
			texto_opcao_dificuldade(dificuldade),
			texto_opcao_cenario(),
			texto_opcao_sons(),
			texto_opcao_tema(),
			" ",
			" ",
			"================================",
			"Pressione [ ENTER ] para iniciar o jogo",
			"Pressione [ ESPAÇO ] para exibir o placar",
			"Pressione [ ESC ] para sair"
		}
		
		desenhar_fundo_cenario()

		se (exibir_intermitencia)
		{
			desenhar_popup(itens, indice_opcao_selecionada())
		}
		senao
		{
			desenhar_popup(itens, -1)
		}
		
		desenhar_borda_cenario()
		g.renderizar()
	}

	funcao desenhar_popup(cadeia itens[], inteiro selecao)
	{
		g.definir_tamanho_texto(14.0)
		g.definir_cor(tema[COR_TEXTO])
		g.definir_estilo_texto(falso, falso, falso)
		
		inteiro borda_vertical = 10
		inteiro borda_horizontal = 30
		inteiro largura = calcular_largura_menu(itens) + (borda_horizontal * 2)
		inteiro altura = calcular_altura_menu(itens) + (borda_vertical * 2)
		inteiro x = (largura_tela / 2) - (largura / 2)
		inteiro y = ((altura_tela + ALTURA_PAINEL_PONTUACAO) / 2) - (altura / 2)
		
		g.definir_cor(tema[COR_FUNDO])
		g.desenhar_retangulo(x, y, largura, altura, falso, verdadeiro)
		
		g.definir_cor(tema[COR_BORDA])
		g.desenhar_retangulo(x, y, largura, altura, falso, falso)

		inteiro x_item = x + borda_horizontal, y_item = y + borda_vertical, largura_item = calcular_largura_menu(itens), altura_item
		inteiro centro_x, centro_y
		
		para (inteiro i = 0; i < u.numero_elementos(itens); i++)
		{
			cadeia item = itens[i]
			
			altura_item = calcular_altura_item_quadro(item)			
			centro_x = x_item + (largura_item / 2) - (g.largura_texto(item) / 2)
			centro_y = y_item + (altura_item / 2) - (g.altura_texto(item) / 2)
			
			g.desenhar_texto(centro_x, centro_y, item)

			se (selecao == i)
			{
				g.desenhar_texto(centro_x - g.largura_texto(">>") - 5, centro_y, ">>")
				g.desenhar_texto(centro_x + g.largura_texto(item) + 5, centro_y, "<<")
			}
			
			y_item = y_item + altura_item
		}
	}
	
	funcao inteiro indice_opcao_selecionada()
	{
		escolha (opcao_menu_serpente)
		{
			caso OPCAO_NOVO_JOGO	: retorne 4
			caso OPCAO_DIFICULDADE	: retorne 5
			caso OPCAO_CENARIO		: retorne 6
			caso OPCAO_SONS		: retorne 7
			caso OPCAO_TEMA		: retorne 8
		}
		retorne 4
	}	

	funcao inteiro calcular_altura_menu(cadeia itens[])
	{
		inteiro altura = 0
		para (inteiro i = 0; i < u.numero_elementos(itens); i++)
		{
			altura = altura + calcular_altura_item_quadro(itens[i])
		}
		retorne altura
	}

	funcao inteiro calcular_largura_menu(cadeia itens[])
	{
		real largura = 0.0
		para (inteiro i = 0; i < u.numero_elementos(itens); i++)
		{
			largura = mat.maior_numero(tp.inteiro_para_real(g.largura_texto(itens[i])), largura)
		}
		retorne tp.real_para_inteiro(largura)
	}

	funcao inteiro calcular_altura_item_quadro(cadeia item)
	{
		se (item != " ") { retorne g.altura_texto(item) + 7 }
		senao { retorne 4 }
	}

	funcao cadeia texto_opcao_continuar()
	{
		se (continuar) { retorne "Continuar" }
		senao { retorne "Novo Jogo" }		
	}

	funcao cadeia texto_opcao_dificuldade(inteiro opcao_dificuldade)
	{
		cadeia texto_dificuldade = "Dificuldade: "

		escolha (opcao_dificuldade)
		{
			caso MUITO_FACIL	: retorne texto_dificuldade + "Muito Fácil"
			caso FACIL		: retorne texto_dificuldade + "Fácil"
			caso MEDIO		: retorne texto_dificuldade + "Médio"
			caso DIFICIL		: retorne texto_dificuldade + "Difícil"
			caso MUITO_DIFICIL	: retorne texto_dificuldade + "Muito Difícil"
			caso CHUCK_NORRIS	: retorne texto_dificuldade + "Chuck Norris"
		}
		retorne "Dificuldade inválida"
	}

	funcao cadeia texto_opcao_sons()
	{
		se (reproduzir_sons) { retorne "Reproduzir Sons: Sim" }
		senao { retorne "Reproduzir Sons: Não" }
	}

	funcao cadeia texto_opcao_cenario()
	{
		se (cenario_circular) { retorne "Cenário Circular: Sim" }
		senao { retorne "Cenário Circular: Não" }
	}

	funcao cadeia texto_opcao_tema()
	{
		retorne "Tema: " + TEMAS[tema_atual][NOME_TEMA]
	}
	
	funcao recomecar()
	{
		inteiro coluna_central = (COLUNAS / 2)
		inteiro linha_inicial = LINHAS - TAMANHO_INICIAL_SERPENTE - 1

		tamanho_serpente = TAMANHO_INICIAL_SERPENTE
		CAUDA = tamanho_serpente - 1

		para (inteiro SEGMENTO = CABECA; SEGMENTO <= CAUDA; SEGMENTO++)
		{
			serpente[SEGMENTO][COLUNA] = coluna_central
			serpente[SEGMENTO][LINHA] = linha_inicial + SEGMENTO
			serpente[SEGMENTO][DIRECAO] = ACIMA
		}

		ultimo_estado_cauda[LINHA] = serpente[CAUDA][LINHA]
		ultimo_estado_cauda[COLUNA] = serpente[CAUDA][COLUNA]
		ultimo_estado_cauda[DIRECAO] = serpente[CAUDA][DIRECAO]

		fruta_especial_ativa = falso
		contador_comidas_normais = 0
		efeito_ativo = -1
		duracao_efeito = 0

		atualizar_posicao_comida()
		pontuacao_jogador = 0
		tempo_inicio_jogo = u.tempo_decorrido()
		tempo_total_jogo = 0		
	}

	funcao tela_jogo()
	{
		interromper_musica_menu()
		reproduzir_musica_jogo()

		se (nao continuar) { recomecar() }		

		habilitar_continuacao_jogo()
		aguardar_inicio()
		tempo_inicio_jogo = u.tempo_decorrido() - tempo_total_jogo
		
		enquanto (tela_atual == JOGO)
		{
			tempo_total_jogo = u.tempo_decorrido() - tempo_inicio_jogo
			tempo_inicio_frame = u.tempo_decorrido()
	
			atualizar_jogo_serpente()
			desenhar_tela_jogo()
			g.renderizar()

			sincronizar_taxa_de_atualizacao()
			
			se (t.tecla_pressionada(t.TECLA_ESC))
			{
				ir_para_a_tela(MENU)
				u.aguarde(200)
			}
		}

		salvar_jogo()
	}

	funcao sincronizar_taxa_de_atualizacao()
	{
		tempo_decorrido_frame = u.tempo_decorrido() - tempo_inicio_frame
		
		inteiro intervalo = INTERVALO_ATUALIZACAO[dificuldade]
		se (efeito_ativo == FRUTA_GELO)
		{
			intervalo = intervalo * 3
		}

		tempo_restante_frame = intervalo - tempo_decorrido_frame 

		se (tempo_restante_frame > 0)
		{				
			u.aguarde(tempo_restante_frame)
		}
	}

	funcao aguardar_inicio()
	{
		para (inteiro i = 3; i >= 1; i--)
		{
			cadeia itens[] =
			{
				"Prepare-se para jogar!!",
				"Iniciando em: " + i
			}
			
			desenhar_tela_jogo()
			desenhar_popup(itens, -1)
			g.renderizar()

			reproduzir_som_comida()
			u.aguarde(1000)			
		}

		reproduzir_som_comida()
	}

	funcao habilitar_continuacao_jogo()
	{
		pode_continuar = verdadeiro
		continuar = verdadeiro
	}	

	funcao reproduzir_musica_jogo()
	{
		se (reproduzir_sons e rep_musica_jogo < 0)
		{
			rep_musica_jogo = sm.reproduzir_som(musica_jogo_serpente, verdadeiro)
		}
	}

	funcao atualizar_posicao_comida()
	{
		comida[LINHA]  = u.sorteia(0, LINHAS  - 1)
		comida[COLUNA] = u.sorteia(0, COLUNAS - 1)

		enquanto (local_comida_invalido())
		{
			comida[COLUNA] = (comida[COLUNA] + 1) % COLUNAS

			se (comida[COLUNA] == 0)
			{
				comida[LINHA]  = (comida[LINHA]  + 1) % LINHAS
			}
		}
	}

	funcao logico local_comida_invalido()
	{
		para (inteiro SEGMENTO = CABECA; SEGMENTO <= CAUDA; SEGMENTO++)
		{
			se (comida[LINHA] == serpente[SEGMENTO][LINHA] e comida[COLUNA] == serpente[SEGMENTO][COLUNA])
			{
				retorne verdadeiro
			}
		}
		retorne falso
	}

	funcao atualizar_jogo_serpente()
	{
		ler_entrada_usuario()
		
		atualizar_posicao_segmentos()
		atualizar_posicao_cabeca()
		atualizar_estado_jogo()

		se (duracao_efeito > 0)
		{
			duracao_efeito = duracao_efeito - 1

			se (efeito_ativo == FRUTA_FOGO)
			{
				pontuacao_jogador = pontuacao_jogador + 1
			}

			se (duracao_efeito <= 0)
			{
				efeito_ativo = -1
			}
		}
	}

	funcao atualizar_estado_jogo()
	{
		se (serpente_bateu())
		{
			reproduzir_som_derrota()
			retroceder_serpente()
			ir_para_a_tela(DERROTA)
		}
		senao
		{
			se (serpente_pegou_comida())
			{
				reproduzir_som_comida()
				aumentar_serpente()
				atualizar_pontuacao()
				
				contador_comidas_normais = contador_comidas_normais + 1

				se (contador_comidas_normais >= 3 e nao fruta_especial_ativa)
				{
					gerar_fruta_especial()
					contador_comidas_normais = 0
				}

				se (tamanho_serpente < TAMANHO_MAXIMO_SERPENTE)
				{				
					atualizar_posicao_comida()
				}
				senao
				{
					ir_para_a_tela(VITORIA)
				}
			}

			se (fruta_especial_ativa)
			{
				se (serpente_pegou_fruta_especial())
				{
					reproduzir_som_comida()
					aplicar_efeito_fruta_especial()
					fruta_especial_ativa = falso
				}
				senao
				{
					tempo_spawn_fruta = tempo_spawn_fruta - 1
					se (tempo_spawn_fruta <= 0)
					{
						fruta_especial_ativa = falso
					}
				}
			}
		}
	}

	funcao gerar_fruta_especial()
	{
		fruta_especial[LINHA]  = u.sorteia(0, LINHAS  - 1)
		fruta_especial[COLUNA] = u.sorteia(0, COLUNAS - 1)
		tipo_fruta_especial    = u.sorteia(0, 4)

		enquanto (local_fruta_especial_invalido())
		{
			fruta_especial[COLUNA] = (fruta_especial[COLUNA] + 1) % COLUNAS

			se (fruta_especial[COLUNA] == 0)
			{
				fruta_especial[LINHA]  = (fruta_especial[LINHA]  + 1) % LINHAS
			}
		}

		fruta_especial_ativa = verdadeiro
		tempo_spawn_fruta = 180 
	}

	funcao aplicar_efeito_fruta_especial()
	{
		escolha (tipo_fruta_especial)
		{
			caso FRUTA_FOGO:
				efeito_ativo = FRUTA_FOGO
				duracao_efeito = 100
				pontuacao_jogador = pontuacao_jogador + (VALOR_COMIDA[dificuldade] * 3)
				pare

			caso FRUTA_GELO:
				efeito_ativo = FRUTA_GELO
				duracao_efeito = 80
				pare

			caso FRUTA_PEDRA:
				efeito_ativo = FRUTA_PEDRA
				duracao_efeito = 120
				pare

			caso FRUTA_RAIO:
				pontuacao_jogador = pontuacao_jogador + (VALOR_COMIDA[dificuldade] * 5)
				teleportar_cabeca_segura()
				pare

			caso FRUTA_VENTO:
				encolher_serpente_vento()
				pare
		}
	}

	funcao teleportar_cabeca_segura()
	{
		inteiro nova_linha = 0, nova_coluna = 0
		logico posicao_valida = falso

		enquanto (nao posicao_valida)
		{
			nova_linha = u.sorteia(2, LINHAS - 3)
			nova_coluna = u.sorteia(2, COLUNAS - 3)
			posicao_valida = verdadeiro

			para (inteiro i = CABECA + 1; i <= CAUDA; i++)
			{
				se (serpente[i][LINHA] == nova_linha e serpente[i][COLUNA] == nova_coluna)
				{
					posicao_valida = falso
					pare
				}
			}
		}

		serpente[CABECA][LINHA] = nova_linha
		serpente[CABECA][COLUNA] = nova_coluna
	}

	funcao encolher_serpente_vento()
	{
		inteiro corte = 3
		enquanto (corte > 0 e tamanho_serpente > TAMANHO_INICIAL_SERPENTE)
		{
			CAUDA = CAUDA - 1
			tamanho_serpente = tamanho_serpente - 1
			corte = corte - 1
		}
	}

	funcao logico local_fruta_especial_invalido()
	{
		se (fruta_especial[LINHA] == comida[LINHA] e fruta_especial[COLUNA] == comida[COLUNA])
		{
			retorne verdadeiro
		}

		para (inteiro SEGMENTO = CABECA; SEGMENTO <= CAUDA; SEGMENTO++)
		{
			se (fruta_especial[LINHA] == serpente[SEGMENTO][LINHA] e fruta_especial[COLUNA] == serpente[SEGMENTO][COLUNA])
			{
				retorne verdadeiro
			}
		}
		retorne falso
	}

	funcao logico serpente_pegou_fruta_especial()
	{
		retorne (serpente[CABECA][LINHA] == fruta_especial[LINHA] e serpente[CABECA][COLUNA] == fruta_especial[COLUNA])
	}

	funcao reproduzir_som_derrota()
	{
		se (reproduzir_sons) { sm.reproduzir_som(som_derrota, falso) }
	}
	
	funcao reproduzir_som_comida()
	{
		se (reproduzir_sons) { sm.reproduzir_som(som_comida, falso) }
	}
	
	funcao atualizar_pontuacao()
	{
		inteiro valor = VALOR_COMIDA[dificuldade]

		se (efeito_ativo == FRUTA_FOGO)
		{
			valor = valor * 3
		}

		se (cenario_circular)
		{		
			valor = tp.real_para_inteiro(mat.maior_numero(valor / 2.0, 1.0))
		}
			
		pontuacao_jogador = pontuacao_jogador + valor
	}

	funcao retroceder_serpente()
	{
		para (inteiro SEGMENTO = CABECA; SEGMENTO < CAUDA; SEGMENTO++)
		{
			serpente[SEGMENTO][LINHA] = serpente[SEGMENTO + 1][LINHA]
			serpente[SEGMENTO][COLUNA] = serpente[SEGMENTO + 1][COLUNA]
			serpente[SEGMENTO][DIRECAO] = serpente[SEGMENTO + 1][DIRECAO]
		}

		serpente[CAUDA][LINHA] 	= ultimo_estado_cauda[LINHA]
		serpente[CAUDA][COLUNA] 	= ultimo_estado_cauda[COLUNA]
		serpente[CAUDA][DIRECAO] = ultimo_estado_cauda[DIRECAO]
	}

	funcao aumentar_serpente()
	{	
		inteiro linha = serpente[CAUDA][LINHA]
		inteiro coluna = serpente[CAUDA][COLUNA]
		inteiro direcao = serpente[CAUDA][DIRECAO]

		CAUDA = CAUDA + 1

		serpente[CAUDA][LINHA]   = linha
		serpente[CAUDA][COLUNA]  = coluna
		serpente[CAUDA][DIRECAO] = direcao

		tamanho_serpente = tamanho_serpente + 1
	}

	funcao logico serpente_bateu()
	{
		retorne (cabeca_bateu_parede() ou cabeca_bateu_corpo())
	}

	funcao logico cabeca_bateu_parede()
	{
		inteiro linha = serpente[CABECA][LINHA]
		inteiro coluna = serpente[CABECA][COLUNA]

		se (efeito_ativo == FRUTA_PEDRA)
		{
			se (linha < 0) { serpente[CABECA][LINHA] = LINHAS - 1 }
			senao se (linha >= LINHAS) { serpente[CABECA][LINHA] = 0 }

			se (coluna < 0) { serpente[CABECA][COLUNA] = COLUNAS - 1 }
			senao se (coluna >= COLUNAS) { serpente[CABECA][COLUNA] = 0 }

			retorne falso
		}

		se (linha < 0 ou linha >= LINHAS) { retorne verdadeiro }
		se (coluna < 0 ou coluna >= COLUNAS) { retorne verdadeiro }

		retorne falso
	}

	funcao logico cabeca_bateu_corpo()
	{
		se (efeito_ativo == FRUTA_PEDRA)
		{
			retorne falso
		}

		para (inteiro SEGMENTO = CABECA + 1; SEGMENTO <= CAUDA; SEGMENTO++)
		{
			se 
			(
				serpente[CABECA][LINHA] == serpente[SEGMENTO][LINHA] e
				serpente[CABECA][COLUNA] == serpente[SEGMENTO][COLUNA]
			)
			{
				retorne verdadeiro
			}			
		}
		retorne falso
	}

	funcao logico serpente_pegou_comida()
	{
		retorne (serpente[CABECA][LINHA] == comida[LINHA] e serpente[CABECA][COLUNA] == comida[COLUNA])		
	}

	funcao atualizar_posicao_cabeca()
	{
		se (serpente[CABECA][DIRECAO] == ACIMA)
		{
			se (cenario_circular)
			{
				serpente[CABECA][LINHA] = (LINHAS + serpente[CABECA][LINHA] - 1) % LINHAS 
			}
			senao { serpente[CABECA][LINHA] = serpente[CABECA][LINHA] - 1 }
		}
		senao se (serpente[CABECA][DIRECAO] == ABAIXO)
		{
			se (cenario_circular)
			{
				serpente[CABECA][LINHA] = (serpente[CABECA][LINHA] + 1) % LINHAS 
			}
			senao { serpente[CABECA][LINHA] = serpente[CABECA][LINHA] + 1 }
		}
		senao se (serpente[CABECA][DIRECAO] == ESQUERDA)
		{
			se (cenario_circular)
			{
				serpente[CABECA][COLUNA] = (COLUNAS + serpente[CABECA][COLUNA] - 1) % COLUNAS
			}
			senao { serpente[CABECA][COLUNA] = serpente[CABECA][COLUNA] - 1 }
		}
		senao se (serpente[CABECA][DIRECAO] == DIREITA)
		{
			se (cenario_circular)
			{
				serpente[CABECA][COLUNA] = (COLUNAS + serpente[CABECA][COLUNA] + 1) % COLUNAS
			}
			senao { serpente[CABECA][COLUNA] = serpente[CABECA][COLUNA] + 1 }
		}
	}

	funcao ler_entrada_usuario()
	{		
		se ((dificuldade != CHUCK_NORRIS e t.tecla_pressionada(t.TECLA_SETA_ACIMA)) ou (dificuldade == CHUCK_NORRIS e t.tecla_pressionada(t.TECLA_SETA_ABAIXO)))
		{
			se (serpente[CABECA + 1][DIRECAO] != ABAIXO)
			{
				serpente[CABECA][DIRECAO] = ACIMA
			}
		}
		senao se ((dificuldade != CHUCK_NORRIS e t.tecla_pressionada(t.TECLA_SETA_ABAIXO)) ou (dificuldade == CHUCK_NORRIS e t.tecla_pressionada(t.TECLA_SETA_ACIMA)))
		{
			se (serpente[CABECA + 1][DIRECAO] != ACIMA)
			{
				serpente[CABECA][DIRECAO] = ABAIXO
			}
		}
		senao se ((dificuldade != CHUCK_NORRIS e t.tecla_pressionada(t.TECLA_SETA_ESQUERDA)) ou (dificuldade == CHUCK_NORRIS e t.tecla_pressionada(t.TECLA_SETA_DIREITA)))
		{
			se (serpente[CABECA + 1][DIRECAO] != DIREITA)
			{
				serpente[CABECA][DIRECAO] = ESQUERDA
			}
		}
		senao se ((dificuldade != CHUCK_NORRIS e t.tecla_pressionada(t.TECLA_SETA_DIREITA)) ou (dificuldade == CHUCK_NORRIS e t.tecla_pressionada(t.TECLA_SETA_ESQUERDA)))
		{
			se (serpente[CABECA + 1][DIRECAO] != ESQUERDA)
			{			
				serpente[CABECA][DIRECAO] = DIREITA
			}
		}
	}

	funcao atualizar_posicao_segmentos()
	{
		ultimo_estado_cauda[LINHA] = serpente[CAUDA][LINHA]
		ultimo_estado_cauda[COLUNA] = serpente[CAUDA][COLUNA]
		ultimo_estado_cauda[DIRECAO] = serpente[CAUDA][DIRECAO]
		
		para (inteiro SEGMENTO = CAUDA; SEGMENTO > CABECA; SEGMENTO--)
		{
			inteiro SEGMENTO_ANTERIOR = SEGMENTO - 1
			
			serpente[SEGMENTO][LINHA  ] = serpente[SEGMENTO_ANTERIOR][LINHA  ]
			serpente[SEGMENTO][COLUNA ] = serpente[SEGMENTO_ANTERIOR][COLUNA ]
			serpente[SEGMENTO][DIRECAO] = serpente[SEGMENTO_ANTERIOR][DIRECAO]
		}
	}

	funcao desenhar_tela_jogo()
	{
		desenhar_fundo_cenario()
		desenhar_pontuacao_serpente()
		desenhar_tempo_jogo()
		desenhar_serpente()
		desenhar_comida()
		desenhar_fruta_especial()
		desenhar_borda_cenario()
	}

	funcao desenhar_fruta_especial()
	{
		se (fruta_especial_ativa)
		{
			inteiro x = BORDA_CENARIO + (fruta_especial[COLUNA] * tamanho_segmento) + 1
			inteiro y = ALTURA_PAINEL_PONTUACAO + BORDA_CENARIO + (fruta_especial[LINHA] * tamanho_segmento) + 1

			/* Alterna a cor de fundo entre amarelo (0xFFFF00) e preto (0x000000) a cada 250 milissegundos */
			se ((u.tempo_decorrido() / 250) % 2 == 0)
			{
				g.definir_cor(0xFFFF00)
			}
			senao
			{
				g.definir_cor(0x000000)
			}

			g.desenhar_retangulo(x - 2, y - 2, tamanho_segmento + 4, tamanho_segmento + 4, falso, verdadeiro)

			desenhar_objeto(fruta_especial[COLUNA], fruta_especial[LINHA], imagens_frutas_especiais[tipo_fruta_especial])
		}
	}

	funcao desenhar_pontuacao_serpente()
	{
		inteiro x = BORDA_CENARIO
		inteiro y = 10

		g.definir_tamanho_texto(16.0)
		g.definir_cor(tema[COR_TEXTO])
		g.definir_estilo_texto(falso, falso, falso)
		
		cadeia texto_pontos = "Pts: " + pontuacao_jogador
		
		se (efeito_ativo == FRUTA_FOGO)
		{
			texto_pontos = texto_pontos + " [FOGO 3X: " + duracao_efeito + "]"
		}
		senao se (efeito_ativo == FRUTA_GELO)
		{
			texto_pontos = texto_pontos + " [GELO SLOW: " + duracao_efeito + "]"
		}
		senao se (efeito_ativo == FRUTA_PEDRA)
		{
			texto_pontos = texto_pontos + " [PEDRA INVENCÍVEL: " + duracao_efeito + "]"
		}

		g.desenhar_texto(x, y, texto_pontos)
	}

	funcao desenhar_tempo_jogo()
	{
		cadeia tempo = "Tempo: " + formatar_tempo(tempo_total_jogo)

		g.definir_tamanho_texto(16.0)
		g.definir_cor(tema[COR_TEXTO])
		g.definir_estilo_texto(falso, verdadeiro, falso)
		
		inteiro x = largura_tela - BORDA_CENARIO - g.largura_texto(tempo)
		inteiro y = 10
		
		g.desenhar_texto(x, y, tempo)
	}

	funcao cadeia formatar_tempo(inteiro tempo)
	{
		inteiro segundos = (tempo / 1000 ) % 60
		inteiro minutos  = (tempo / 60000)
		
		cadeia min = txt.preencher_a_esquerda('0', 2, "" + minutos )
		cadeia seg = txt.preencher_a_esquerda('0', 2, "" + segundos)

		retorne min + ":" + seg
	}
	
	funcao desenhar_fundo_cenario()
	{
		g.definir_cor(tema[COR_FUNDO])
		g.limpar()		
	}

	funcao desenhar_borda_cenario()
	{
		inteiro x1 = BORDA_CENARIO - 1
		inteiro y1 = BORDA_CENARIO + ALTURA_PAINEL_PONTUACAO - 1
		inteiro x2 = largura_tela - BORDA_CENARIO - 1		
		inteiro y2 = altura_tela  - BORDA_CENARIO  - 1
		
		g.definir_cor(tema[COR_BORDA])
		
		g.desenhar_linha(x1, y1, x2, y1)
		g.desenhar_linha(x1, y2, x2, y2)
		g.desenhar_linha(x1, y1, x1, y2)
		g.desenhar_linha(x2, y1, x2, y2)
	}

	funcao desenhar_serpente()
	{
		desenhar_objeto(serpente[CABECA][COLUNA], serpente[CABECA][LINHA], imagem_segmento)
		
		para (inteiro SEGMENTO = 1; SEGMENTO <= CAUDA; SEGMENTO++)
		{
			desenhar_objeto(serpente[SEGMENTO][COLUNA], serpente[SEGMENTO][LINHA], imagem_segmento)
		}

		desenhar_objeto(serpente[CAUDA][COLUNA], serpente[CAUDA][LINHA], imagem_segmento)
	}

	funcao desenhar_objeto(inteiro coluna, inteiro linha, inteiro imagem)
	{
		inteiro x = BORDA_CENARIO + (coluna * tamanho_segmento) + 1
		inteiro y = ALTURA_PAINEL_PONTUACAO + BORDA_CENARIO + (linha * tamanho_segmento) + 1

		g.desenhar_imagem(x, y, imagem)
	}

	funcao desenhar_comida()
	{
		desenhar_objeto(comida[COLUNA], comida[LINHA], imagem_comida)
	}
	
	funcao finalizar_serpente()
	{
		liberar_sons()
		liberar_imagens()
		g.encerrar_modo_grafico()
	}

	funcao liberar_imagens()
	{
		g.liberar_imagem(imagem_segmento)
		g.liberar_imagem(imagem_comida)

		para (inteiro i = 0; i < 5; i++)
		{
			g.liberar_imagem(imagens_frutas_especiais[i])
		}
	}

	funcao liberar_sons()
	{
		sm.liberar_som(musica_jogo_serpente)
		sm.liberar_som(musica_menu_serpente)
		sm.liberar_som(som_comida)
		sm.liberar_som(som_derrota)
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

		se (imagem_fundo_menu_pong == -1)
		{
			imagem_fundo_menu_pong = g.carregar_imagem("pong/Fundos_e_Bola/fundo_menu_pong.png")
			g.liberar_imagem(botao_habilidade1)
			g.liberar_imagem(botao_habilidade2)
			g.redimensionar_imagem(botao_habilidade1, 100, 50, falso)
			g.redimensionar_imagem(botao_habilidade2, 100, 50, falso)
			g.redimensionar_imagem(imagem_fundo_menu_pong, tela_w, tela_h, falso)
		}
		
		estado_pong = MENU_PONG
		opcao_menu_pong = 0

		se (canal_lobby == -1)
			canal_lobby = sm.reproduzir_som(som_lobby, verdadeiro)
		
		enquanto (estado_pong != SAIR_PONG)
		{
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
			
			g.renderizar()
			u.aguarde(16)
		}
		
		se (canal_lobby != -1)
		{
			sm.interromper_som(canal_lobby)
			canal_lobby = -1
		}

		g.sair_modo_tela_cheia()
		g.definir_dimensoes_janela(785, 1024)
		g.definir_fonte_texto("Poetsen One")
		g.definir_titulo_janela("Menu de Opções")
		m.exibir_cursor()
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

	funcao reset_pontuacao()
	{
		g.definir_cor(cor_fundo)
		g.desenhar_retangulo(0, 0, tela_w, tela_h, falso, verdadeiro)
		g.definir_cor(cor_principal)
		desenhar_pontuacao()
		se (pontuacao_img != -1) g.liberar_imagem(pontuacao_img)
		pontuacao_img = g.renderizar_imagem(tela_w, tela_h/12)
	}

	funcao gerar_imagens()
	{
		gerar_fundo()
		campo[IMAGEM] = g.renderizar_imagem(tela_w, tela_h)
		g.desenhar_retangulo(0, 0, tela_w, tela_h, falso, verdadeiro)
		player1[IMAGEM] = g.renderizar_imagem(player1[LARGURIA], player1[ARTURIA])
		g.desenhar_retangulo(0, 0, tela_w, tela_h, falso, verdadeiro)
		player2[IMAGEM] = g.renderizar_imagem(player2[LARGURIA], player2[ARTURIA])
		g.desenhar_retangulo(0, 0, tela_w, tela_h, falso, verdadeiro)
		bolinha[IMAGEM] = g.renderizar_imagem(bolinha[LARGURIA], bolinha[ARTURIA])
		reset_pontuacao()
	}

	funcao inicializar()
	{
		g.iniciar_modo_grafico(verdadeiro)
		g.entrar_modo_tela_cheia()
		m.ocultar_cursor()
		
		g.carregar_fonte("pong/PressStart2P.ttf")
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

		portugol = g.carregar_imagem("pong/portugol.png")
		imagem_fundo_pong = g.carregar_imagem("pong/Fundos_e_Bola/campo.png")
		
		branco = g.COR_BRANCO
		verde = g.criar_cor(52, 229, 0)
		
		colision_music = sm.carregar_som("pong/Sons/colision.wav")
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

		player1[X] = campo[X]
		player1[ARTURIA] = tamanho_tile*4
		player1[LARGURIA] = tamanho_tile
		player1[Y] = campo[Y] + (campo[ARTURIA]/2)
		player1[PONTUACAO_PONG] = 0

		player2[X] = campo[X] + campo[LARGURIA] - tamanho_tile-100
		player2[ARTURIA] = tamanho_tile*4
		player2[LARGURIA] = tamanho_tile
		player2[Y] = campo[Y] + (campo[ARTURIA]/2)
		player2[PONTUACAO_PONG] = 0

		se (img_batedor1 != -1) g.redimensionar_imagem(img_batedor1, player1[LARGURIA], player1[ARTURIA], falso)
		se (img_batedor1_meio != -1) g.redimensionar_imagem(img_batedor1_meio, player1[LARGURIA], player1[ARTURIA], falso)
		se (img_batedor1_fim != -1) g.redimensionar_imagem(img_batedor1_fim, player1[LARGURIA], player1[ARTURIA], falso)
		
		se (img_batedor2 != -1) g.redimensionar_imagem(img_batedor2, player2[LARGURIA], player2[ARTURIA], falso)
		se (img_batedor2_meio != -1) g.redimensionar_imagem(img_batedor2_meio, player2[LARGURIA], player2[ARTURIA], falso)
		se (img_batedor2_fim != -1) g.redimensionar_imagem(img_batedor2_fim, player2[LARGURIA], player2[ARTURIA], falso)
		
		se (bola_beisebol != -1) g.redimensionar_imagem(bola_beisebol, 40, 40, falso)
		
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

		botao_habilidade1 = g.carregar_imagem("pong/Habilidades/Habilidade_Reb1.png")
		botao_habilidade2 = g.carregar_imagem("pong/Habilidades/Habilidade_Reb2.png")

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
		g.desenhar_retangulo(player2[X]+75 - forca2*8, player2[Y]-15, forca2*13, 10, falso, verdadeiro)
		
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
 
	funcao desenhar_menu_pong()
	{
		se (imagem_fundo_menu_pong != -1)
			g.desenhar_imagem(0, 0, imagem_fundo_menu_pong)
		senao
		{
			g.definir_cor(g.COR_PRETO)
			g.limpar()
		}
		
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
				item_p1 = (i+1) + ". " + nomes_upgrades[i] + " (Nvl: " + lvl_upg_p1[i] + "/1)"
				g.desenhar_texto(x_coluna1, y_pos, item_p1)
				g.definir_cor(g.COR_VERMELHO)
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
				item_p2 = (i+1) + ". " + nomes_upgrades[i] + " (Nvl: " + lvl_upg_p2[i] + "/1)"
				g.desenhar_texto(x_coluna2, y_pos, item_p2)
				g.definir_cor(g.COR_VERMELHO)
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
        senao se (i == 0) // Rebatida Aleatória (passiva) – compra níveis até o máximo (5)
        {
            se (lvl_upg_p1[0] < 5 e strikecoins_p1 >= custo_upg[0])
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
            se (lvl_upg_p2[0] < 5 e strikecoins_p2 >= custo_upg[0])
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
 * @POSICAO-CURSOR = 16805; 
 * @DOBRAMENTO-CODIGO = [94, 228, 234, 238, 244, 248, 341, 379, 449, 447, 443, 463, 493, 497, 485, 506, 527, 539, 545, 537, 551, 565, 581, 586, 591, 595, 573, 600, 569, 563, 611, 609, 607, 622, 626, 638, 646, 620, 676, 680, 657, 694, 690, 688, 686, 710, 702, 734, 730, 746, 724, 752, 769, 773, 779, 783, 777, 764, 762, 796, 794, 849, 814, 868, 808, 903, 874, 921, 916, 937, 935, 942, 946, 929, 927, 953, 959, 967, 1008, 1006, 1013, 1002, 1019, 1081, 1067, 1027, 1118, 1125, 1135, 1132, 1147, 1144, 1159, 1157, 1171, 1166, 1187, 1182, 1198, 1207, 1205, 1221, 1219, 1245, 1249, 1243, 1255, 1259, 1263, 1269, 1267, 1237, 1233, 1284, 1282, 1293, 1297, 1291, 1306, 1310, 1304, 1322, 1326, 1320, 1336, 1334, 1344, 1354, 1358, 1350, 1367, 1373, 1365, 1381, 1379, 1388, 1395, 1416, 1420, 1393, 1461, 1451, 1429, 1473, 1471, 1487, 1484, 1497, 1494, 1504, 1510, 1520, 1516, 1532, 1538, 1544, 1557, 1549, 1601, 1590, 1579, 1616, 1623, 1611, 1633, 1631, 1629, 1650, 1658, 1656, 1673, 1669, 1664, 1684, 1682, 1680, 1704, 1709, 1700, 1692, 1718, 1734, 1740, 1744, 1726, 1752, 1761, 1758, 1750, 1724, 1716, 1780, 1776, 1770, 1792, 1790, 1834, 1832, 1826, 1821, 1849, 1846, 1859, 1866, 1864, 1857, 1874, 1879, 1884, 1893, 1898, 1889, 1908, 1906, 1920, 1935, 1945, 1940, 1964, 1975, 1969, 1962, 1983, 1992, 1990, 2000, 1998, 2008, 2006, 2016, 2014, 1988, 2028, 2026, 2035, 2033, 2042, 2040, 2049, 2047, 2024, 2062, 2056, 2072, 2091, 2095, 2085, 2083, 2117, 2121, 2125, 2106, 2133, 2147, 2158, 2164, 2183, 2179, 2191, 2199, 2204, 2216, 2211, 2222, 2301, 2392, 2410, 2408, 2431, 2371, 2455, 2444, 2470, 2462, 2496, 2504, 2514, 2598, 2596, 2625, 2527, 2654, 2652, 2650, 2648, 2676, 2680, 2670, 2688, 2701, 2698, 2696, 2694, 2718, 2715, 2713, 2711, 2734, 2741, 2744, 2748, 2753, 2756, 2760, 2767, 2778, 2781, 2788, 2793, 2728, 2805, 2810, 2803, 2819, 2824, 2816, 2834, 2839, 2832, 2848, 2853, 2845, 2800, 2861, 2877, 2890, 2873, 2867, 2911, 2924, 2907, 2901, 2937, 2935, 2951, 2957, 2949, 2967, 2974, 2989, 2979, 2965, 3006, 3027, 3000, 3039, 3058, 3033, 2998, 3072, 3069, 3081, 3078, 3090, 3087, 3099, 3096, 3108, 3105, 3066, 3122, 3149, 3136, 3118, 3165, 3170, 3179, 3177, 3190, 3175, 3196, 3163, 3242, 3249, 3270, 3277, 3231, 3203, 3302, 3307, 3319, 3324, 3315, 3334, 3332, 3312, 3344, 3349, 3360, 3364, 3357, 3374, 3372, 3354, 3384, 3299, 3405, 3410, 3400, 3419, 3417, 3393, 3391, 3442, 3449, 3447, 3457, 3464, 3462, 3472, 3477, 3433, 3502, 3508, 3500, 3493, 3551, 3549, 3561, 3559, 3572, 3577, 3570, 3587, 3585, 3598, 3609, 3619, 3651, 3657, 3663, 3633, 3675, 3684, 3691, 3708, 3706, 3700, 3722, 3728, 3734, 3755, 3740, 3772, 3776, 3774, 3780, 3770, 3789, 3793, 3791, 3797, 3787, 3762, 3807, 3809, 3811, 3816, 3804, 3825, 3822, 3835, 3844, 3831, 3856, 3854, 3868, 3866, 3880, 3878, 3898, 3895, 3908, 3905, 3890, 3922, 3932, 3943, 3954, 3965, 3974, 3916, 3989, 3983, 4013, 4008, 4002, 4022, 4033, 4048, 4059, 4054, 4068, 4066, 4075, 4083, 4081, 4095, 4101, 4110, 4107, 4119, 4127, 4144, 4166, 4180, 4207, 4213, 4219, 4225, 4234, 4240, 4246, 4231, 4211, 4205, 4279, 4284, 4293, 4298, 4289, 4318, 4323, 4332, 4337, 4328, 4254, 4349, 4357, 4363, 4371, 4376, 4369, 4386, 4392, 4400, 4405, 4398, 4415, 4353, 4347, 4423, 4469, 4472, 4460, 4489, 4492, 4480, 4507, 4515, 4523, 4531, 4504, 4502, 4545, 4553, 4561, 4569, 4542, 4540, 4500, 4582, 4589, 4594, 4599, 4605, 4610, 4615, 4620, 4586, 4580, 4638, 4640, 4642, 4628, 4653, 4659, 4657, 4651];
 * @PONTOS-DE-PARADA = ;
 * @SIMBOLOS-INSPECIONADOS = ;
 * @FILTRO-ARVORE-TIPOS-DE-DADO = inteiro, real, logico, cadeia, caracter, vazio;
 * @FILTRO-ARVORE-TIPOS-DE-SIMBOLO = variavel, vetor, matriz, funcao;
 */