#!/bin/bash

create_project() {
	nvim --headless +"CreateProject $*" +qa
}
