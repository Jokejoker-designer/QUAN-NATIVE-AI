# Work orders cho Cursor — sau nghiệm thu 09/09

Đọc MASTER_CLOSURE_PLAN.md cùng thư mục. Đây là prompt chuẩn bị, **chưa gửi** vào Cursor/Grok, không tự đổi LOOP_STATE. Root live D:/FPGA/FPGG_ART_Y_ASTRA_NATIVE_V1_RESEARCH. Target Arty A7-100T xc7a100tcsg324-1, Vivado2026.1. PROGRAM=NO cho mọi task dưới đây.

Áp dụng chung: đọc AGENTS và đúng reference Xilinx trước script; ACK task/session/base và ownership; giữ18 KEEP, official MIG/DDR models và toàn bộ old bags; new named modules/bags; không reset/clean/reclone/push; không sửa audit tree Antigravity. Freeze oracle/source/config/includes trước run. Lưu commands, exits, raw logs, pre/post hashes, first divergence, limitations. Không self-close letter; independent auditor kiểm rồi Grok/Codex cập nhật scope. Không thay threshold hoặc sửa old expected sau FAIL. Tối đa một corrective revision có nguyên nhân cụ thể.

## WO-00 — ASTRA-C0-CLOSE-CONTRACT-RECONCILE-01

Unknown: có thể định nghĩa một contract C1–C6 không tự mâu thuẫn và đúng product target hiện hành không?

Read-only source, chỉ viết bag mới và proposed contract. Đối chiếu Master§9–13, chỉ đạo§550 và WO0550. Ghi rõ: §550 nói về learner, không tự cấm/retire LM06; learned compact generator là candidate chứ không chỉ vì module có tên LM06. Phân biệt C3_PREBOARD_VERIFIED và C3_BOARD_CONFIRMED; C6 ready trước C7.

Deliverables: DECISIONS.md, REQUIRED_EVIDENCE.json, canonical hierarchy/input-image map, contract fields chưa freeze. Không đặt C4_MASTER closed/LM06_BYTE256 frozen. Không sửa C0 cũ. Done khi mọi clause map tới đúng artifact/test và ownership; còn kiến trúc model chưa quyết định thì đánh dấu rõ, không block các fix transport/persistence độc lập.

## WO-01 — ASTRA-C5-EXPLICIT-REWARD-AND-FULLSTATE-01

Đây là work package; chia 01A và01B để một run không trộn root causes.

01A Unknown: chỉ packet reward hợp lệ mới thay bank SGD của canonical C3.
- Loại bỏ auto+3 của candidate mới, không thay live original.
- UART command query không update; reward packet echo actual pending session/txn/model generation, scalar[-3,+3], CRC/length.
- Latch payload tại handshake; duplicate/stale/freeze/range rejection; do not wire current txn back as proof of host echo validation.
- Tests: inference twice no weight delta; -3/+3/0 vs full-vector symmetric oracle; one-cycle request then bus mutate; duplicate/wrong generation/CRC; read-back toàn32weight. Check ACK/commit boundary.

01B Unknown: DDR restore khôi phục đúng32weight + pending state trên cùng bank dùng inference, không accumulator C2 riêng.
- Giữ C2 KEEP. Tạo serialization backend mới và interface snapshot/load; không feed reward như substitute cho weight vector.
- Versioned A/B image: header/session/model/schema/sequence/length, full payload, checksum, commit marker. Freeze memory map.
- Candidate COMMITTED/PERSISTED nghĩa rõ; guard false success. Cache-capacity/dirty-eviction policy; không half-load inference.
- Tests: nhiều weight nonzero sau training; snapshot → clear cả on-chip bank/pending → reload qua AXI/MIG → exact32weight/identity/behavior. TB không force/load weight except independent unit baseline setup trước exam.
- Interrupt write ở từng beat/B response, corruption/version mismatch, late response, reset và duplicate replay. So sánh normal/no-restore control.
- Bắt buộc retain r4 grant-through-R/B, WSTRB và skid-buffer regression. Không gọi local accumulator+3 là restored learned state.

Pass của01A không close01B. 01B pass XSim/MIG là preboard persistence, không power-loss NVM hoặc board.

## WO-02 — ASTRA-C4-CONDITIONAL-GEN-FEASIBILITY-01

Unknown: compact learned token generator thực sự phụ thuộc prefix/evidence có đáp ứng bounded-domain quality trong resource plan không?

Không thực hiện WO0550 sửa lại bag cũ hoặc tự đóng C4 chỉ vì20 mẫu. Bước đầu là falsifier/source audit current head:
- Bias load0/1/63: current V[5:0]=0 bug phải được chứng minh bằng test failing trong bag mới.
- Giữ evidence, đổi prefix input: current head không đổi distribution; ghi dependency gap.
- Giữ prefix, đổi decisive fact/relation/context: evaluate full output, không object-ID equality.

Sau đó tạo model/data feasibility proposal tối đa2 rivals, không tải model/cloud training ngoài scope. Có thể dùng compact conditional recurrent/sequence decoder hoặc LM06-compatible reduced candidate; declare architecture compatibility với Master, không tự chọn “large is forbidden” hoặc “0BRAM means correct”. No expensive training until dataset/compute/checkpoint plan concrete.

Freeze token law: byte256 hoặc bounded vocab64 + exact dictionary; không gọi V64 là full byte256. Dataset train/dev/heldout tách entities/worlds/phrases, nhiều câu có token đầu giống nhau và tiếp diễn khác; no answer-target field supplied at query time. Materializer inputs actual full proof facts/text; high-ID và variable query phải rõ.

Minimum evidence: trained checkpoint provenance, integer reference, prefix intervention, evidence removal/replacement, zero/corrupt weights, EOS/MAX. Metrics grounded accuracy>=90%, unsupported-safe>=95%, hallucinated fact<=5%, termination100% với denominators và số mẫu freeze. Safety gate độc lập với weights. 20 class-ID outputs không đạt task.

Done feasibility có measured candidate quality/latency/memory estimate và kiến trúc reviewable, chưa tự C4 close. Nếu không đạt: first failure classes + một corrective hypothesis, giữ old head control. Không giảm chuẩn hoặc dựng host sentence.

## WO-03 — ASTRA-C1-C3-CANONICAL-IMAGE-TRANSFER-01

Chỉ chạy sau01B và C1 image contract sẵn sàng. Unknown: current canonical full path giữ C1 selectivity và đạt C3 transfer sau DDR reload trên đúng serialized corpus.

- Reuse C1 KEEP; export full image/index/dictionary with hash/coverage; cross-check procedural model against bytes. Không dùng query-specific ctx overlay làm hidden answer insertion. Context/refinement law phải giống builder và DUT.
- CAND_CAP16 chỉ giữ nếu actual selected profile đạt; freeze DDR_QUERY_BOUND từ full bus traffic đúng phase, không một sample1632B.
- Auditor kiểm C1 raw per-class recall>=95%, reduction>=90% tạiN>=4096, representation100%, leaks/status. N800k actual image và high-ID/overflow pages phải resolve; không generation vô nghĩa rồi không truy cập.
- >=5 independent train seeds/streams, shared A, frozen B, shuffled C, identity D + fixed-validity baseline. Pair same test worlds, disjoint entities where claimed; bounded preference task giữa legal paths, no gold feature.
- Kết quả per seed with counts/coverage/CI; gain>=10pp, paired lower>0, A>shuffle, explicit per-ID comparison. Flush/clear/reload full32weight and rerun, drop<=5pp.
- Negative query/proof/conflict/search-incomplete guards chạy trên same hierarchy. No TB restore w[1:31].

Pass=>C1 production-image preboard và C3 statistical preboard có phạm vi, C7 silicon episode còn mở. Không circular block chỉ vì chưa program.

## WO-04 — ASTRA-C5-UART-STREAM-AND-AXI-ERRORS-01

Chia04A token transport và04B AXI error transport, mỗi subtask có new bag.

04A: replacement C4 đã có stream contract; UART phát toàn sequence>=3 token+EOS, không last_gen-only. Real clock/115200 parameters; pin-level decode cùng final top. Backpressure FIFO full/stalls, consecutive commands, malformed/overflow. Clock/baud simulation overrides được ghi riêng và final build không được mang8000/800.

04B: đưa RID/RRESP/RLAST/BID/BRESP/WSTRB qua canonical adapters. Không fabricate OKAY. Outstanding owner giữ đến last response được consume. Inject bad/stalled/late/reordered-within-contract reads, AW/W/B independent stalls, reset/drain; assert client receives exactly one response or explicit fail, never silently drop accepted beat. Giữ r4 fix provenance.

## WO-05 — ASTRA-C5-CANONICAL-LETTER-REGRESSION-01

Prereq01A/B,03,04 và C4 learned candidate accepted. Unknown: một hierarchy cùng config/images/model chạy mọi feature không có shortcut.

Compile identity traverse từ final candidate top; không chỉ grep module names. Trace UART→C1→descriptors→proof/rank→pending→full persist→materializer→generator→UART. C4Q và C4G siblings không ghép PASS.

Unified matrix: role reversal, direct/novel2hop, decisive edge delete/replace/reverse, conflict, unrelated, candidate/path overflow, explicit reward/heldout/full-state reload, grounded generation, transport errors. Host chỉ codec/image load/reward/detokenize/log; test controller không force internal FSM/data/weights. Expose counters for audit nhưng constants không là proof.

Deliver preboard C5 acceptance matrix all requirements tied raw artifact/line/hash; no benchmark qid/plant-as-corpus/test override reachable in final config.

## WO-06 — ASTRA-C6-FINAL-REPRODUCIBLE-FREEZE-01

Prereq05; không reroute C6 cũ để chữa C4 chưa đạt. Unknown: exact accepted full system fits/times/rebuilds.

Cursor chuẩn bị pin accepted source commit/config/includes/XDC/IP/corpus/index/vocab/checkpoint/init-state. Không git clean/reset; preserve all dirty unrelated work and failed bags. Build clean output directory from manifest; verify correct clock/baud and no sim stub.

Hard limits: WNS>=0,TNS0,WHS>=0,THS0,route error0,DRC error0,device fit,critical unconstrained0,CDC reviewed. Review synthesized hierarchy/pruning: no entire learned/output path optimized away by constants. Reuse valid MIG/IP assets, no handwritten mig.prj edits. Report actual slices/LUT/FF/BRAM/DSP and memory-client traffic; not sum OOC.

Emit bit SHA and reproducible manifest. C6_PREBOARD_READY only, never board PASS from route. Any source/model/schema change invalidates final bit match and reopens affected gate. C7 program permission must bind exact new bit/images/board owner separately.

## Prompt gửi ngay cho Cursor

Thực hiện WO-00 và lập01A làm next writer duy nhất sau kiểm ownership. Read MASTER_CLOSURE_PLAN.md trước. Bắt đầu bằng regression chứng minh inference không reward hiện đang tự update và bias-load guard C4 bị vô hiệu hóa; không sửa C1/C2 KEEP hoặc old bags. Tạo named revision rồi sửa explicit reward interface, giữ oracle/symmetric law. C4 feasibility là workstream độc lập chỉ khi write scope tách và không đè cùng C5 file. Báo ACK, actual evidence, first divergence và gate scope; không tự đóng C3–C6. PROGRAM=NO.
