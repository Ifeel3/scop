NAME	= scop.jar
JDK		= jdk-17.0.3.1/bin
JAVA	= $(JDK)/java
JAVAC	= $(JDK)/javac
JAR		= $(JDK)/jar
LWJGLL	= $(shell find . -name *.jar | tr '\n' ':')
LWJGLM	= $(shell find . -name *.jar | tr '\n' ':')
UNAME 	= $(shell uname)
SRC		= $(shell find . -name *.java)
OBJ		= $(SRC:%.java=%.class)

.PHONY: all clean fclean re

%.class: %.java
ifeq ($(UNAME), Linux)
	@$(JAVAC) -d target -cp "$(LWJGLL)" $?
endif
ifeq ($(UNAME), Darwin)
	@$(JAVAC) -d target -cp "$(LWJGLM)" $?
endif

all: $(NAME)

compile: jdk-17.0.3.1 $(OBJ)
	@echo Compile...
ifeq ($(UNAME), Linux)
	@cd target && ../$(JAR) -cfm ../$(NAME) ../src/main/java/Manifest-linux.mf *
endif
ifeq ($(UNAME), Darwin)
	@cd target && ../$(JAR) -cfm ../$(NAME) ../src/main/java/Manifest-macOS.mf *
endif

$(NAME): compile
	@echo Execute...
	@$(JAVA) -jar $(NAME)

jdk-17.0.3.1:
	@echo Downloading JDK...
ifeq ($(UNAME), Linux)
	@curl -s -o jdk.tar.gz https://download.oracle.com/java/17/archive/jdk-17.0.3.1_linux-x64_bin.tar.gz
endif
ifeq ($(UNAME), Darwin)
	@curl -s -o jdk.tar.gz https://download.oracle.com/java/17/archive/jdk-17.0.3.1_macos-x64_bin.tar.gz
endif
	@echo Extracting...
	@tar -xf jdk.tar.gz
	@rm -f jdk.tar.gz

clean:
	@echo Clean...
	@rm -rf target
	@rm -f $(NAME)

fclean: clean
	@rm -rf jdk-17.0.3.1

re: clean all