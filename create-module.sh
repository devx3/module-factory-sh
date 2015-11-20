#!/bin/bash
##############################################
#
# This script provides a folder's hierarchy 
# for magento module modules and start a 
# git repository 
# 
# @author Erick Bruno
# @date   19/11/2015
#
##############################################

#INIT 0 - Configure the constants
MODULES_FOLDER=$(pwd)/modules
MVERSION="0.0.1"

MFOLDER=("local" "community" "core")

if [ ! -d $MODULES_FOLDER ]; then
	echo "The module's folder doesn't exist, creating..."
	mkdir $MODULES_FOLDER
	echo "DONE!"
	sleep 1
fi

#INIT 1 - defining names and folders
read -p "Company Name: "
CNAME=$REPLY
read -p "Module Name: "
MNAME=$REPLY

# Set the module name, eg: CompanyName/FirstModule
MFOLDER=$MODULES_FOLDER/$CNAME/$MNAME

# Set up the base folders for the module
FOLDERS=(
"app/etc/modules"
"app/code/local/$CNAME/$MNAME"
"app/code/local/$CNAME/$MNAME/etc"
"app/code/local/$CNAME/$MNAME/Model"
"app/code/local/$CNAME/$MNAME/controllers"
"app/code/local/$CNAME/$MNAME/Helper"
"app/code/local/$CNAME/$MNAME/Block"
)

CONFIGFILES=(
"app/etc/modules/${CNAME}_${MNAME}.xml"
"app/code/local/$CNAME/$MNAME/etc/config.xml"
"app/code/local/$CNAME/$MNAME/Helper/Data.php"
)

# INIT 2 - Creating the module hierarchy
i=0
while [ $i != ${#FOLDERS[@]} ]; do
	echo "Creating: ${FOLDERS[$i]}"
	mkdir -p $MFOLDER/${FOLDERS[$i]}
	((i++))
done

# INIT 3 - Creating the config files
# Creating the module config file
echo "Creating: ${CONFIGFILES[0]}"
cat >> $MFOLDER/${CONFIGFILES[0]} << EOF
<?xml version="1.0"?>
<!--
/**
 * Magento
 *
 * NOTICE OF LICENSE
 *
 * This source file is subject to the Open Software License (OSL 3.0)
 * that is bundled with this package in the file LICENSE.txt.
 * It is also available through the world-wide-web at this URL:
 * http://opensource.org/licenses/osl-3.0.php
 * If you did not receive a copy of the license and are unable to
 * obtain it through the world-wide-web, please send an email
 * to suporte.developer@buscape-inc.com so we can send you a copy immediately.
 *
 * @category   $CNAME
 * @package    ${CNAME}_${MNAME}
 * @copyright  Copyright (c) $(date +%Y) $CNAME <erickfabiani123@gmail.com>
 * @license    http://opensource.org/licenses/osl-3.0.php  Open Software License (OSL 3.0)
 */
-->
<config>
    <modules>
        <${CNAME}_${MNAME}>
            <active>true</active>
            <codePool>local</codePool>
        </${CNAME}_${MNAME}>
    </modules>    
</config>
EOF
echo "DONE!"

# Creating de config.xml
echo "Creating: ${CONFIGFILES[1]}"
cat >> $MFOLDER/${CONFIGFILES[1]} << EOF
<?xml version="1.0"?>
<config>
    <modules>
        <${CNAME}_${MNAME}>
            <version>$MVERSION</version>
        </${CNAME}_${MNAME}>
    </modules>
    
    <global>
        <blocks>
            <${CNAME,,}_${MNAME,,}>
                <class>${CNAME}_${MNAME}_Block</class>
            </${CNAME,,}_${MNAME,,}>
        </blocks>
        <helpers>
            <${CNAME,,}_${MNAME,,}>
                <class>${CNAME}_${MNAME}_Helper</class>
            </${CNAME,,}_${MNAME,,}>
        </helpers>
        
        <models>
            <${CNAME,,}_${MNAME,,}>
                <class>${CNAME}_${MNAME}_Model</class>
            </${CNAME,,}_${MNAME,,}>
        </models>
    </global>
</config>
EOF
echo "DONE!"

# Creating the data helper
echo "Creating: ${CONFIGFILES[2]}"
cat >> $MFOLDER/${CONFIGFILES[2]} << EOF
<?php

class ${CNAME}_${MNAME}_Helper_Data 
    extends Mage_Core_Helper_Abstract {
}
EOF
echo "DONE!"
