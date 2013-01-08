doctype 5                                                                                                                                                                                         
html lang: 'en', ->                                                                                                                                                                                              
  head ->                                                                                                                                                                                            
    meta charset: 'utf-8'                                                                                                                                                                            
    title 'Portfolio Igniter'                                                                                                                                                                        
    link href: 'styles/bootstrap.css', rel: 'stylesheet', type: 'text/css'                                                                                                                           
    link href: 'styles/bootstrap-responsive-min.css', rel: 'stylesheet', type: 'text/css'                                                                                                            
    link href: 'styles/render.css', rel: 'stylesheet', type: 'text/css'                                                                                                                              
    script type: 'text/javascript', src: 'scripts/jquery.js'                                                                                                 
    script type: 'text/javascript', src: 'scripts/jquery-parallax-1-1.js'                                                                                                                            
    script type: 'text/javascript', src: 'scripts/bootstrap-scrollspy.js'                                                                                                                            
    script type: 'text/javascript', src: 'scripts/bootstrap-collapse.js'                                                                                                                             
    script type: 'text/javascript', src: 'scripts/jquery-localscroll-1-2-7-min.js'                                                                                                                   
    script type: 'text/javascript', src: 'scripts/jquery-scrollTo-1-4-2-min.js'                                                                                                                      
    script type: 'text/javascript', ->                                                                                                                                                               
      comment '//\r\nif (screen.width <= 699) {\r\ndocument.location = "http://augustinas.eu/dev/4/mobile.html";\r\n};\r\nif ((navigator.userAgent.match(/iPhone/i)) || (navigator.userAgent.match(/i
Pod/i))) {\r\n   location.replace("http://augustinas.eu/dev/4/mobile.html");\r\n};\r\n//'                                                                                                            
    link href: 'http://fonts.googleapis.com/css?family=Lato:100,300,400,700,900,100italic,300italic,400italic,700italic,900italic', rel: 'stylesheet', type: 'text/css'                              
    style '#page {opacity:0;}'                                                                                                                                                                       
  body '#page', 'data-spy': 'scroll', 'data-offset': '10', ->                                                                                                                                             
    header ->                                                                                                                                                                                        
      div '.navbar.navbar-fixed-top', ->                                                                                                                                                             
        div '.navbar-inner', ->                                                                                                                                                                      
          div '.container-fluid', ->                                                                                                                                                                 
            a '.btn.btn-navbar', 'data-toggle': 'collapse', 'data-target': '.nav-collapse', ->                                                                                                            
              span '.icon-bar'                                                                                                                                                                       
              span '.icon-bar'                                                                                                                                                                       
              span '.icon-bar'                                                                                                                                                                       
            div '.nav-collapse', ->                                                                                                                                                                  
              ul '#navi.nav', ->                                                                                                                                                                     
                li ->                                                                                                                                                                                
                  a href: '#home', 'Home'                                                                                                                                                            
                li ->                                                                                                                                                                                
                  a href: '#second', 'About'                                                                                                                                                         
                li ->                                                                                                                                                                                
                  a href: '#third', 'Portfolio'                                                                                                                                                      
                li ->                                                                                                                                                                                
                  a href: '#fourth', 'Fourth'                                                                                                                                                        
                li ->                                                                                                                                                                                
                  a href: '#fifth', 'Contact'    
                  
    -> @content
        
    comment 'footer'                                                                                                                                                                                 
    footer '.footer', ->                                                                                                                                                                             
      div '.row', ->                                                                                                                                                                                 
        div '.span2', ->                                                                                                                                                                             
          a '.btn.btn-inverse', href: '', ->                                                                                                                                                          
            i '.icon-bookmark'                                                                                                                                                                       
            text 'Bookmark'                                                                                                                                                                          
        comment 'sample button'                                                                                                                                                                      
        div '.span3', ->                                                                                                                                                                             
          p '&copy; Killer Confidence 2013'                                                                                                                                                          
    comment '/footer'                                                                                                                                                                                
    comment 'Le JS'                                                                                                                                                                                  
    script '$(document).ready(function(){\r\n\t$(\'#navi\').localScroll(800);\r\n\tRepositionNav();\r\n\t$(window).resize(function(){\r\n\t\tRepositionNav();\r\n\t});\t\r\n\t// .parallax(xPosition,
 adjuster, inertia, outerHeight) options:\r\n\t// xPosition - Horizontal position of the element.\r\n\t// adjuster - y position to start from.\r\n\t// inertia - speed to move relative to vertical s
croll. Example: 0.1 is one tenth the speed of scrolling, 2 is twice the speed of scrolling.\r\n\t// outerHeight (true/false) - Whether or not jQuery should use it\'s outerHeight option to determine
 when a section is in the viewport.\r\n\t$(\'#intro\').parallax("50%", 0, 0.1, true);\r\n\t$(\'#second\').parallax("50%", 0, 0.1, true);\r\n\t$(\'.bg\').parallax("5%", 3000, 0.8, true);\r\n\t$(\'.b
g2\').parallax("30%", 3500, 0.8, true);\r\n\t$(\'#third\').parallax("50%", 0, 0.1, true);\r\n\t$(\'#fourth\').parallax("50%", 0, 0.1, true);\r\n})\r\n\t$(\'#navbar\').scrollspy();'                 
    script '$(".collapse").collapse()'                                                                                                                                                               
    comment 'page fade effect - this simple trick first waits for page to load(images, content) and after it\'s loaded fades it. You can remove it by deleting this section.'                        
    comment 'read documentation'                                                                                                                                                                     
    script '$(document).ready(function() {\r\n\t$(\'#page\').fadeTo(1500, 1);\r\n});'                                                                                                                
    comment '/page fade effect'    