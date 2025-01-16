library(dplyr)
library(magrittr)
library(visNetwork)
library(htmlwidgets)

nodes <- data.frame(
  label = c("Kelly Baker", 
            "Fanta Gutema",
            "Blessing Mberu",
            "John Agira",
            "Christine Amondi",
            "Phylis Busienei",
            "Bonphace Okoth",
            "Sheillah Simiyu",
            "Innocent Tumwebaze",
            "Abdhalah Ziraba",
            "Dan Sewell", 
            "Sriram Pemmeraju",
            "Sabin Gaire",
            "Daniel Kakou",
            "Alexis Kapanka",
            "Luis Torres",
            "Mark Krysan",
            "Gabriele Villarini",
            "John Kessler",
            "Tan Nguyen",
            "Collins Ouma",
            "Jairus Abuom",
            "Marsha Sharon",
            "Abisola Osinuga",
            "Ellie Madson"),
  group = 
    c("SUNY Buffalo",
      "Univ. of Memphis",
      rep("APHRC",8),
      rep("Univ. of Iowa",10),
      rep("Maseno Univ.",3),
      "Univ. N. Carolina",
      "SUNY Buffalo"),
  image = 
    paste("https://myweb.uiowa.edu/dksewell/pathome",
          c("kelly_baker.jpg",
            "fanta_gutema.jpg",
            "blessing_mberu.jpg",
            "john_agira.jpg",
            "christine_amondi.jpg",
            "phylis_busienei.jpg",
            "bonphace_okoth.jpg",
            "sheillah_simiyu.jpg",
            "innocent_tumwebaze.jpg",
            "abdhalah_ziraba.jpg",
            "sewell-mugshot.jpg",
            "sriram_pemmaraju.jpg",
            "sabin_gaire.png",
            "daniel_kakou.jpg",
            "alexis_kapanka.jpg",
            "luis_torres.jpg",
            "krysan_mark.jpg",
            "gabriele_villarini.jpg",
            "",# "Block IOWA GOLD-ffcd00-TM.png",
            "tan_nguyen.jpg",
            "collins_ouma.png",
            "jairus_abuom.jpg",
            "marsha_sharon.jpg",
            "abisola_osinuga.jpg",
            "ellie_madson.jpg"),
          sep = "/")#,
  # email = c("kkbaker@buffalo.edu", 
  #           "daniel-sewell@uiowa.edu",
  #           "bmberu@aphrc.org",
  #           "sriram-pemmaraju@uiowa.edu")
) %>% 
  mutate(id = 1:n(),
         shape = "image", image = image)
edges = 
  rbind(c(1,2),
        c(1,3),
        c(1,4),
        c(1,5),
        c(1,7),
        c(1,11),
        c(1,15),
        c(1,16),
        c(1,18),
        c(1,21),
        c(1,24),
        c(1,25),
        c(3,6),
        c(3,8),
        c(3,9),
        c(3,10),
        c(3,11),
        c(11,12),
        c(11,13),
        c(11,14),
        c(11,17),
        c(11,18),
        c(12,19),
        c(12,20),
        c(18,16),
        c(21,22),
        c(21,23)
        ) %>% 
  as.data.frame()
colnames(edges) = c("from","to")

visNetwork(nodes, edges) %>%
  visOptions(
    highlightNearest = TRUE,
    nodesIdSelection = TRUE
    #   list(
    #   enabled = TRUE,
    #   values = setNames(nodes$id, nodes$group),
    #   useLabels = TRUE
    # )
  ) %>% 
  saveWidget("C:/Users/dksewell/Documents/pathomelab.github.io/people_network.html",
             selfcontained = TRUE)
