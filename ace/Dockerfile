FROM cp.icr.io/cp/icp4i/ace/ibm-ace-server-prod:11.0.0.8-r1-amd64

RUN mkdir -p /home/aceuser/bars
COPY *.bar /home/aceuser/bars
RUN chown aceuser:aceuser /home/aceuser/bars
RUN ace_compile_bars.sh
