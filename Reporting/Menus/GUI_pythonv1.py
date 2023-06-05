import sys
from PyQt5.QtWidgets import QApplication, QWidget, QVBoxLayout, QHBoxLayout, QPushButton, QLineEdit, QTextEdit
from subprocess import Popen, PIPE

class PowerShellGUI(QWidget):
    def __init__(self):
        super().__init__()
        self.setWindowTitle("PowerShell GUI")
        self.setGeometry(200, 200, 600, 400)

        # Create widgets
        self.command_input = QLineEdit()
        self.run_button1 = QPushButton("Run")
        self.output_box = QTextEdit()
        self.run_button2 = QPushButton("Stop")

        # Create layouts
        input_layout = QHBoxLayout()
        input_layout.addWidget(self.command_input)
        input_layout.addWidget(QPushButton("Run"))
        input_layout.addWidget(QPushButton("Stop"))

        main_layout = QVBoxLayout()
        main_layout.addLayout(input_layout)
        main_layout.addWidget(self.output_box)

        # Set main layout
        self.setLayout(main_layout)

        # Connect button click event to function
        self.run_button1.clicked.connect(self.run_command)
        self.run_button2.clicked.disconnect(self.run_command)

    def run_command(self):
        command = self.command_input.text()
        process = Popen(["powershell.exe", command], stdout=PIPE)
        output, errors = process.communicate()
        if errors:
            self.output_box.setText(errors.decode())
        else:
            self.output_box.setText(output.decode())

if __name__ == "__main__":
    app = QApplication(sys.argv)
    gui = PowerShellGUI()
    gui.show()
    sys.exit(app.exec_())
