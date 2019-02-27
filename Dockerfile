FROM perl:5


RUN curl -L https://github.com/maxmind/libmaxminddb/releases/download/1.3.2/libmaxminddb-1.3.2.tar.gz | tar -xz
RUN cd libmaxminddb-1.3.2 && \
    ./configure && \
    make && \
    make check && \
    make install && \
    ldconfig && \
    cd

RUN curl -L https://cpanmin.us | perl - App::cpanminus
RUN cpanm local::lib
RUN ARCHFLAGS="-arch x86_64" cpanm MaxMind::DB::Writer::Tree Net::Works::Network
# RUN cpanm Devel::Refcount MaxMind::DB::Reader::XS MaxMind::DB::Writer::Tree Net::Works::Network GeoIP2 Data::Printer

COPY scripts /scripts
COPY data /data

ENV PATH=/scripts:$PATH

CMD ["json_to_mmdb"]
