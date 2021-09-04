# ProjektWOT2D
Pomysł projektu tego typu zaczął się sam rysować w naszych głowach, gdy tylko zostaliśmy poinformowani o konieczności wykonania gry na FPGA. Było to dla nas tym bardziej intuicyjne, gdyż jesteśmy zapalonymi i doświadczonymi graczami dużej produkcji Wargaming pt. „World of Tanks”. W ramach naszej mini gry sterujemy pojazdami reprezentującymi czołgi używając standardu komunikacji SPI i PS2. Pojazdy poruszają się na utworzonej przestrzeni będącą swoistą mapą gry a interakcja jest zapewniona przez interfejs UART. Wszystko to wyświetlane na monitorze VGA. W momencie startu pojawia się menu, po wciśnięciu przycisku Battle, użytkownik wchodzi do gry i oczekuje na wejście przeciwnika. Za pomocą joystika gracz steruje czołgiem, a wciśnięcie lewego przycisku myszy powoduje strzał - pod warunkiem, że na wyświetlaczu 4 cyfrowym widnieje napis "rdY". Trafionemu czołgowi zmniejsza się pasek HP. Po 10 trafieniach w pojazd przeciwnika użytkownik wygrywa i gra się kończy.

Na potrzeby projektu zostało stworzone konto ProjektWOT na githubie. Repozytorium prowadzą: Orzeł Łukasz, Świebocki Jakub.
