from PyQt6.QtWidgets import QApplication, QWidget, QPushButton, QVBoxLayout

class Example(QWidget):
    
    def __init__(self):
        super().__init__()
        
        self.initUI()
        
        
    def initUI(self):
        
        # Create a button
        button = QPushButton('Click me!', self)
        
        # Connect button clicked signal to function
        button.clicked.connect(self.buttonClicked)
        
        # Create a vertical layout and add button to it
        vbox = QVBoxLayout()
        vbox.addWidget(button)
        
        # Set the layout for the window
        self.setLayout(vbox)
        
        # Set window properties
        self.setGeometry(300, 300, 250, 150)
        self.setWindowTitle('PyQt6 Example')
        
        
    def buttonClicked(self):
        print('Button clicked')
        
        
if __name__ == '__main__':
    
    # Create an application object
    app = QApplication([])
    
    # Create an instance of the Example class
    ex = Example()
    
    # Show the window
    ex.show()
    
    # Run the application
    app.exec()
