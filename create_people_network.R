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
            "Abisola Osinuga"),
  group = 
    c("SUNY Buffalo",
      "Univ. of Memphis",
      rep("APHRC",8),
      rep("Univ. of Iowa",10),
      rep("Maseno Univ.",3),
      "Univ. N. Carolina"),
  image = 
    paste("C:/Users/dksewell/Documents/pathomelab.github.io/",
          c("img/mugshots/kelly_baker.jpg",
            "img/mugshots/fanta_gutema.jpg",
            "img/mugshots/blessing_mberu.jpg",
            "img/mugshots/john_agira.jpg",
            "img/mugshots/christine_amondi.jpg",
            "img/mugshots/phylis_busienei.jpg",
            "img/mugshots/bonphace_okoth.jpg",
            "img/mugshots/sheillah_simiyu.jpg",
            "img/mugshots/innocent_tumwebaze.jpg",
            "img/mugshots/abdhalah_ziraba.jpg",
            "img/mugshots/sewell-mugshot.jpg",
            "img/mugshots/sriram_pemmaraju.jpg",
            "img/mugshots/sabin_gaire.png",
            "img/mugshots/daniel_kakou.jpg",
            "img/mugshots/alexis_kapanka.jpg",
            "img/mugshots/luis_torres.jpg",
            "img/mugshots/krysan_mark.jpg",
            "img/mugshots/gabriele_villarini.jpg",
            "Block IOWA GOLD-ffcd00-TM.png",
            "img/mugshots/tan_nguyen.jpg",
            "img/mugshots/collins_ouma.png",
            "img/mugshots/jairus_abuom.jpg",
            "img/mugshots/marsha_sharon.jpg",
            "img/mugshots/abisola_osinuga.jpg"),
          sep = "/")#,
  # email = c("kkbaker@buffalo.edu", 
  #           "daniel-sewell@uiowa.edu",
  #           "bmberu@aphrc.org",
  #           "sriram-pemmaraju@uiowa.edu")
) %>% 
  mutate(id = 1:n(),
         shape = "image", image = image)
nodes %>% 
  select(id,label)
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
  saveWidget("C:/Users/dksewell/Documents/pathomelab.github.io/people_network.html")
