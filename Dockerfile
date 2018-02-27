FROM debian


RUN apt-get update && apt-get install -y python \
	python-pip \
	python-dev \
	gdebi-core \
	wget \
	libopenblas-dev

RUN apt-key adv --keyserver keys.gnupg.net --recv-key 'E19F5F87128899B192B1A2C2AD5F960A256A04AF'

RUN echo "deb http://cran.univ-paris1.fr/bin/linux/debian stretch-cran34/" >> /etc/apt/sources.list && \
	apt-get update && apt-get install -y r-base gdebi-core wget && \
	pip install tensorflow && \
	R -e "install.packages(c('shiny', 'keras','shinyWidgets', 'shinydashboard' ), repos='https://cran.rstudio.com/')" && \
    	wget --no-verbose https://s3.amazonaws.com/rstudio-shiny-server-os-build/ubuntu-12.04/x86_64/VERSION -O "version.txt" && \
    	VERSION=$(cat version.txt)  && \
    	wget --no-verbose "https://s3.amazonaws.com/rstudio-shiny-server-os-build/ubuntu-12.04/x86_64/shiny-server-$VERSION-amd64.deb" -O ss-latest.deb && \
    	gdebi -n ss-latest.deb && \
	rm -f version.txt ss-latest.deb && \
	cp -R /usr/local/lib/R/site-library/shiny/examples/* /srv/shiny-server/ && \
	rm -rf /var/lib/apt/lists/*

EXPOSE 3838

COPY shiny-server.sh /usr/bin/shiny-server.sh

CMD ["/usr/bin/shiny-server.sh"]

