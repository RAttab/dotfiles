#------------------------------------------------------------------------------#
# Makefile
# Rémi Attab (remi.attab@gmail.com), 08 May 2013
# FreeBSD-style copyright and disclaimer apply
#
# Installs the various dotfiles.
#------------------------------------------------------------------------------#

# Default target. Will be filled up as targets are declared.
all:
.PHONY: all


#------------------------------------------------------------------------------#
# symlink targets
#------------------------------------------------------------------------------#

# Creates a target out of $1 which symlinks $1 to ~/$2/$1
define symlink
$1:
	-rm -f ~/$2/$1
	ln -s ~/dotfiles/$1 ~/$2/$1

.PHONY: $1 # symlinks make bad target so make them phonies.
all: $1
endef

# symlink targets
$(eval $(call symlink,.bashrc))
$(eval $(call symlink,.gdbinit))
$(eval $(call symlink,.htoprc))
$(eval $(call symlink,bin/rloop))


#------------------------------------------------------------------------------#
# .gitconfig
#------------------------------------------------------------------------------#
# Since .gitconfig has per machine customization, we use a fancier 2
# stage mechanism.

~/.gitconfig-head: .gitconfig-head
	cp $< $@

~/.gitconfig: .gitconfig-base ~/.gitconfig-head
	cat ~/.gitconfig-head > $@
	cat .gitconfig-base >> $@

all: ~/.gitconfig