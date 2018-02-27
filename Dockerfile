FROM debian

COPY jranke.asc /jranke.asc
RUN apt-get update && apt-get install -y gnupg && apt-key add /jranke.asc

RUN echo "deb http://cran.univ-paris1.fr/bin/linux/debian stretch-cran34/" >> /etc/apt/sources.list && \
	apt-get update && apt-get install -y python \
	python-pip \
	python-dev \
	gdebi-core \
	wget \
	libopenblas-dev \
	r-base gdebi-core wget && \
	pip install tensorflow && \
	R -e "install.packages(c('shiny', 'keras','shinyWidgets', 'shinydashboard','rmarkdown' ), repos='https://cran.rstudio.com/')" && \
    	wget --no-verbose https://s3.amazonaws.com/rstudio-shiny-server-os-build/ubuntu-12.04/x86_64/VERSION -O "version.txt" && \
    	VERSION=$(cat version.txt)  && \
    	wget --no-verbose "https://s3.amazonaws.com/rstudio-shiny-server-os-build/ubuntu-12.04/x86_64/shiny-server-$VERSION-amd64.deb" -O ss-latest.deb && \
    	gdebi -n ss-latest.deb && \
	rm -f version.txt ss-latest.deb jranke.asc && \
	cp -R /usr/local/lib/R/site-library/shiny/examples/* /srv/shiny-server/ && \
	rm -rf /var/lib/apt/lists/*

EXPOSE 3838

COPY shiny-server.sh /usr/bin/shiny-server.sh

CMD ["bash","/usr/bin/shiny-server.sh"]

