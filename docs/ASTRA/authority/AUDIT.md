# Native AI — audit độc lập Astra, 05-09-2026

## 1. Kết luận kỹ thuật

**Có phần cứng hoạt động thật và có cập nhật trạng thái học thật trong benchmark hẹp. Chưa có đủ bằng chứng cho một Native AI hoàn chỉnh có hiểu ngôn ngữ, suy luận quan hệ và học khái quát trên đường sản xuất thống nhất.**

Gọi toàn bộ dự án là “bịa” là sai với bằng chứng UART/bit/route. Gọi nó là một AI đã hiểu câu hỏi và biết suy luận độc lập cũng vượt quá bằng chứng. Mô tả phù hợp hiện tại: *prototype phần cứng memory-augmented, có benchmark nhân quả của learned prior → Top-K → Transformer output, cùng các prototype frontend/router chưa hội tụ*.

Đây là audit kiến trúc, các báo cáo quan trọng và bằng chứng raw được chọn theo rủi ro; không phải formal verification mọi module, mọi build và mọi lịch sử branch. Không chạy lại board hay full Vivado; không sửa code Grok/Cursor. Các thí nghiệm độc lập trong audit là phân tích offline.

## 2. Cập nhật cuối audit — phải đọc trước các finding lịch sử

Grok tiếp tục làm trong lúc audit. Snapshot mới nhất đã đọc là **d166ca8edc8c01630efbcc648df8001f40dca572**, 05-09-2026 17:03 +07; lúc kiểm khoảng17:09 có Vivado PID44304 đang chạy. Vì vậy không được nói Grok vẫn idle tại e54096f.

Các bản sửa đã đối chiếu thêm:

| Revision | Bằng chứng mới và giới hạn |
|---|---|
| U4A-R4/R5, 917f348/4d8694a | Grok đã ghi nhận/falsify lỗi trả toàn42 corpus của R3; không còn nên nói họ vẫn bảo vệ recall đó |
| U4A-R6, 884aa8c | RTL thêm valid mask từ bind/hit; raw XSim ghi98/98 golden, protocol valid1/key0 PASS |
| PERSIST-IDENTITY-SCHEMA-V2, 342b8c9 | Source flush full32+32 identity và state ở hai beat; raw XSim canonical high-ID hit, alias miss, FAILS=0; C9 graph regression PASS |
| U4-PRE0, d166ca8 | Key map k0..k3, valid capture,4096 buckets; raw XSim geometry PASS, unknown dir=0/emit=0; chính log ghi U4_SEMANTIC=NO |

Chạy độc lập model R6 xác nhận:

- `chiller`: 4/42 candidate; `payroll tax form`: 0.
- `water chiller`: 22/42 candidate, precision4/22≈18,18%, vì context bucket rộng.
- `leak chiller`: cùng4 candidate qua entity cue; packet intent khác nhưng chưa chứng minh ranking phân biệt ý định.
- Hai câu đảo vai trò `pump supplies chiller` / `chiller supplies pump` vẫn cho cùng feature và candidate set.

Do đó F03 universal-zero-bucket và phần truncation của F07 bên dưới là **lỗi lịch sử đã có sửa local**, không còn là cáo buộc lỗi nguyên trạng ở latest HEAD. R6 cải thiện thực; schemaV2 sửa đúng identity transport ở unit level. Chưa có bằng chứng full-chain/board cho bản sửa này. F01, giới hạn hiểu/học F02/F05/F06, scale-law mismatch của R3, shared-feature learning/reasoning và Root-B full-capacity commit vẫn chưa được chứng minh đóng bởi các thay đổi vừa xem.

SchemaV2 giữ epoch header cũ theo prereg: final boot phải có schema/version discriminator hoặc explicit invalidation/migration, để DDR/V1 data không bị reload như V2. Phải audit full AXI address range,65 logical beat slots, reset giữa identity/state và false-commit. Không suy ra unit PASS này đã giải quyết power-loss atomicity.

**NEXT hiện tại không phải làm lại R4/R5/R6 hay sửa lại truncation đã sửa.** Việc còn thiếu là quality/selectivity với actual masked keys trên corpus đủ lớn, full chain schema migration/AXI/commit và các capability gates trong bản thiết kế. Không chèn thêm patch vào run Vivado đang hoạt động.

## 3. Snapshot ban đầu và phạm vi

- Worktree đọc: `D:/Jetking_sem4/SEM_4/arty-a7-online-lm-g14-preboard-00`.
- Branch: `grok-orch/v31-canonical-00`; HEAD lúc bắt đầu: `e54096fa656e1dccc7063fb0e28dd7dc67bfcc00`.
- Master V3.1 SHA256 xác nhận: `2782B12D4022B99BD16CE44D5D54047F32A0F54D82D9DC414B0C619BECA9FF2D`, khớp U0.
- Đã đọc Master V3.1, Appendix A, AGENTS, hard stops, contract freeze, final acceptance §14, skills gate, U3Q/R3 và U4A/R3 prereg/model, RTL frontend, learned graph/store/delta/bind/LM, U1 raw XSim, U2R route/utilization/timing và G14 final-observability binary UART/program/bit.
- Worktree không sạch: 104 entry MIG hiện M; các lần đọc sau còn thấy chỉnh sửa sparse-directory RTL/TB chưa commit và report OOC thay đổi. Vì có writer đang thay đổi file, những finding của U4A-R3 dưới đây gắn với model tại e54096f; không tự quy kết code mới đã PASS.
- BRIDGE vẫn ghi R6 tháng 8 và repoRoot cũ. Đây là stale coordination metadata, không phải trạng thái phần cứng hiện tại.
- Không dùng worktree Cursor cho các thí nghiệm này; không chứng nhận nhánh Cursor trong báo cáo này.

## 4. Phần đã xác minh từ raw evidence

### 3.1 Board artifact có thật

Bag: `results/A7-NATIVE-GRAPH/GROK-ORCH-00/G14-FINAL-OBS-BIT-00/` dưới worktree trên.

Đã tự tính hash file bit: `F24150BDE6F69080B3C5865386C49F6F02300782FFB4037FAF044BB2099840F7`. Raw program stdout ghi đúng JTAG `210319BE776EA`, thiết bị `xc7a100t_0`, startup HIGH và OBS_PROGRAM_DONE. Đây là kiểm tra artifact lưu trên disk, không phải xác nhận bit đang nằm trên board vào lúc audit.

Đã đọc `BOARD/uart_raw.bin`, giải mã bằng hàm CRC/framing đã đọc source trong `python/gate14_uart.py`:

- 30.304 byte, 1.365 frame giải mã hợp lệ.
- SHA256 `FAC30E79FD9E1802C4A4505920A96724CA03CE3709B70FAA7E3A8772D5F486D2`, khớp manifest.
- C10 có `lmst=1`, `lmdn=1`, output 653, 689, 237, 60; `x=0`.
- C9 đi kèm đúng các pack mà báo cáo nêu; frame lặp là snapshot telemetry, không được đếm thành nhiều inference độc lập.
- C12 có teacher/ext_llm và các forbidden counters bằng 0; mode TRAIN=5 và EXAM=8 có xuất hiện.
- Trong các snapshot completion, `r1s/r1r/r1o=0`. RTL `a7ng_g1g5_cofit.sv:170` nối các trường đó về hằng 0. Vì vậy frame này không chứng minh một đường suy luận typed relation đang được xuất ra.

Lưu ý bảo toàn bằng chứng: `uart_raw.txt` hiện có 30.539 byte, hash khác, chỉ giải mã được 1.081 frame. Dùng `.bin` làm raw authority; không dùng file text có thể đã chuyển newline cho dữ liệu nhị phân. Không suy diễn sai hash của `.txt` thành bằng chứng gian lận.

### 3.2 DDR/Top-K thực sự có bằng chứng mô phỏng

`U1-HARNESS-AUTHORITY-FIX-00/audit_xsim.log:2455` ghi PHYS=4, N=64, T_QUERY=275. Dòng 2473/2480 ghi overlap=3, outstanding high-water=2, II_STEADY=40, SAME_RID=1. Dòng 2712/2713 ghi SOA_PATTERN_PASS, delivered=64, axi_bytes=1024, cell_fail=0.

Đây là **MIG_XSIM của workload 64-record**, không phải thời gian một câu trả lời LM, không phải 800k retrieval và không phải silicon throughput.

### 3.3 Tài nguyên post-route có thật, nhưng thuộc candidate U2R

`U2R-RESOURCE-MARGIN-RECOVERY-00/report_utilization_route.rpt`:

| Chỉ tiêu | Đo được |
|---|---:|
| LUT | 36.911 |
| FF | 45.656 |
| Slice | 15.537 / 15.850 — còn 313 |
| BRAM36-equivalent | 106,5 — 106 RAMB36 + 1 RAMB18 |
| DSP | 19 |
| WNS / TNS | +1,126 ns / 0 |
| WHS / THS | +0,014 ns / 0 |
| Routable nets / fully routed | 73.803 / 73.803 |
| Nets with routing errors | 0 |

Không gắn report này cho toàn bộ source HEAD hiện tại: frontend mới và sparse/router mới chưa được chứng minh full-chip bằng report này.

Hierarchy cùng bag: LM dùng 15.752 LUT, 25.035 FF, 98 RAMB36 và 19 DSP; riêng activation 64 RAMB36, weight tile 32. Đường learned-graph u_g1g5 dùng 2.982 LUT; u_soa dùng 10.929 LUT. Chúng đang đồng tồn tại. Đây là căn cứ ưu tiên hợp nhất đường truy xuất trước khi tăng PE.

## 5. Các finding trọng yếu — phân biệt snapshot ban đầu với cập nhật ở §2

### F01 — Benchmark board dùng query ID để tạo ứng viên và tuple học

**EVIDENCE / giới hạn claim mức cao.**

`rtl/native_graph/integrate/a7ng_gate14_c9_glue.sv` định nghĩa T_HOLD_A/A3/A4/B2 và hàm `map_q`; `need_lm` chỉ nhận các mã exam cụ thể. `a7ng_learned_prior_graph.sv:107` trở đi tạo subject/object và candidate qua `fi_of`, `cand_nid`, `cand_s/r/o`, `mix_terms`.

Đặc biệt `S_LATCH` ở khoảng dòng 279–283 lấy tuple học từ qid. Query TRAIN chuyển thẳng S_IDLE→S_LATCH→S_SNAP; không phải chọn một evidence/path trong corpus rồi mới giữ pending winner để nhận reward.

Đây là fixture tốt để test update/persist/epoch/Top-K. Nó không đủ cho claim “host không gián tiếp chỉ định đối tượng học” khi token numeric thực chất chọn tuple bằng công thức. Counters bằng 0 chỉ chứng minh không dùng các port bị cấm đã instrument; không tự chứng minh mọi semantic side channel đều bằng 0.

Master V3.1 §4/§6 đã nhìn nhận đúng vấn đề hai đường. Phải thực hiện U6/U8R; không chỉ sửa tên module thành production.

### F02 — U3Q-R3 khớp RTL, nhưng đang học bằng lexicon của người thiết kế

**EVIDENCE: 98/98 vector phù hợp law. Không phải bằng chứng learned language generalization.**

60 từ trong `qse_lexicon.svh` đã định nghĩa entity/intent/relation/context. Corpus kiểm tra lấy các biến thể sử dụng chính các alias đó. Tỷ lệ 29/30 và 12/12 là kiểm tra nhận diện vocabulary/phrase theo luật đóng băng; chưa có vocab-dev versus sealed lexical test độc lập.

Fixed lexicon là hợp lệ cho parser miền hẹp và không tự động là prompt→answer ROM. Phần phải nói thật: nó chứa prior ngôn ngữ do người thiết kế cung cấp, chưa được FPGA học bằng reward. Chưa có lý do cáo buộc cố tình gian lận chỉ từ việc dùng lexicon.

Thí nghiệm độc lập bằng twin đã được đối chiếu RTL:

- `chiller supplies pump` và `pump supplies chiller` có cùng IDs, cues và k0..k3; chỉ CRC debug có thể khác. Đường feature này không giữ vai trò subject/object.
- Lowest-ID chọn condenser thay pump trong `condenser pump`; đây là failure class đã được Grok công khai.
- Binding bắt đầu từ 0, tối đa 12 byte và rotate trái 1: word cue chỉ có thể dùng tối đa 19 bit thấp; XOR qua các word không tạo 64-bit semantic representation phong phú. Lặp cùng word có thể triệt tiêu cue bằng XOR. Hash không đồng nghĩa semantic embedding.
- Token là raw ASCII 8-bit; giới hạn 48 byte/8 words/12 bytes mỗi word. Appendix lại đề xuất 16-bit token/vocab 4k–16k và miền FPGA, còn demo dùng HVAC. Đây là khoảng cách spec/interface cần giải quyết, không phải chỉ đổi nhãn.

PASS_NARROW của U3Q về law/RTL vẫn có giá trị. Không nâng nó thành “hiểu ngôn ngữ” hay mở rộng claim sang câu tiếng Việt tự do.

### F03 — Recall 100% của P4 xuất hiện vì trả toàn bộ bộ dữ liệu nhỏ

**EVIDENCE bằng chạy hàm model độc lập, không gọi main ghi đè kết quả.**

Trong `U4A-R3-STRUCTURED-QUERY-ROUTER-00/rival_r3.py`, quality corpus chỉ có 42 title. P4 có table k3=intent cue; title entity không có intent nên k3=0. Union qua table này có toàn bộ corpus.

| Query thử độc lập | Candidate union trước bỏ self |
|---|---:|
| chiller | 42/42 |
| condenser pump | 42/42 |
| payroll tax form | 42/42 |
| Tất cả 42 query trong corpus | đều 42/42 |

Khi model bỏ self, còn 41; cap=64 lớn hơn toàn bộ tập. Vì vậy label recall@64=1 không chứng minh router chọn lọc. Trả hết không sai đối với oracle reference, nhưng không thể là bằng chứng thắng sparse retrieval.

`bytes_q=len(cands)*16+n_tables*16` bỏ qua posting ID đã đọc rồi dedup/truncate và các lần đọc metadata. Không thể dùng 720 byte/model làm DDR_QUERY_BOUND_FINAL.

PASS logic ở dòng 239–246 kiểm ngưỡng cho profile tham chiếu P2_8k_h128, trong khi Pareto chọn P4. Bộ kiểm phải áp các điều kiện vào **profile được chọn** và đo precision/negative rejection/candidate reduction, không chỉ recall.

### F04 — Test scale 800k không dùng phân bố key thật

`rival_r3.py:112–113` tạo `k2=nid&0xffff`, `k3=(nid>>4)&0xffff`, trong khi quality/FPGA lấy cue từ chuỗi token. Label “occupancy only” của Grok là trung thực, nhưng vẫn không đủ để chọn geometry cho qse thật.

Chạy lại scale model cho P4 cho coverage=0,32768: 262.144/800.000 ID xuất hiện trong retained heads; **537.856 ID không được đại diện trong bất kỳ retained head nào**. Threshold 20% là quá yếu để support một kho 800k có khả năng truy xuất hữu dụng. Phải phân biệt corpus tồn tại, record có địa chỉ và record có cơ hội được truy xuất.

Không thể đòi exact recall trên mọi dữ liệu tùy ý cùng ngân sách query hữu hạn. Phải công bố workload, index representation đầy đủ, overflow và tỷ lệ abstain. Không được giải quyết mâu thuẫn bằng cách gọi ID-derived occupancy là semantic recall.

**Kết luận U4A-R3: chưa đủ điều kiện freeze production profile.**

### F05 — LM đang active arithmetic; ngôn ngữ và pretrained model chưa được chứng minh

`a7ng_native_v1_ab_core.sv:281–288` có tiny_gpt803k_core thật, nhưng start_train/start_ce/start_corpus nối 0 trong đường tích hợp. Vì vậy online learning hiện tại nằm ở graph state, không phải train toàn bộ Transformer.

`python/ref/a7lm06_fixed_ref.py` mới là oracle 802.816 parameter. File `python/lm/tiny_gpt_ref.py` là model nhỏ 32-vocab, không được dùng một mình để kết luận toàn LM06. Constructor oracle 803k tạo weights pseudo-random seed; các generator test dùng seed=2. **Chưa xác minh được checkpoint language-trained, dữ liệu pretrain, loss/held-out perplexity và provenance của weights đang được boot từ flash.** Không kết luận flash chắc chắn random chỉ từ constructor.

Một số pred nguyên khớp reference là bằng chứng arithmetic, không tự mang nội dung ngôn ngữ. Muốn nói “DDR cần calibration” phải có vocab/model/data và thử generation thực, không được gán nghĩa hậu nghiệm cho 653.

### F06 — Full-ID sideband chưa đi vào LM; input token nội bộ chỉ 8-bit

`a7ng_native_v1_ab_core.sv:284` dùng ctx_pack_o 64-bit. `rtl/native_graph/lm/a7ng_native_ctx_bind.sv` cắt low8 từng ID. `rtl/lm/tiny_gpt803k_core.sv:95,353` lưu token trong mảng 8-bit dù vocabulary output=1024.

Do đó sửa sideband 160-bit không tự sửa input LM. Có hai thiết kế hợp lệ cần version riêng: serialize ID/typed evidence thành nhiều byte token, hoặc nâng toàn token/ctx interface lên 10 bit và chứng minh tương đương/đào tạo phù hợp. Arbitrary database ID cũng không chứa nghĩa đối với LM chưa được học cách đọc evidence.

### F07 — Persistence mất high bits và success có thể không có commit

`a7ng_learned_prior_store.sv:321` ghi subject/object low16; dòng 168 reload bằng zero-extension. Với subject 0xC34FF, sau reload thành 0x34FF. Lookup full32 sẽ miss hoặc alias với record low16 khác. Fixture A000/B000/C000 hiện nằm dưới 65536 nên không phát hiện được.

Ở P_UPD dòng 296–305, ACK và persist_done tăng sau scan dù full 32 slot và không có ghi. Commit_seq chỉ tăng khi ram_we. Đây là lỗi reachability quan trọng khi workload vượt capacity. Root-B audit cũ cũng đã ghi rõ; final promotion phải đóng bằng committed-state evidence.

Context-delta module có phép reward×conf, nhưng learned_prior_store nhận upd_rew chứ không nhận delta_o. Conf được buộc 256 tại learned graph; không nên mô tả đây là thuật toán học representation hoặc đa tầng credit assignment.

DDR persistence trong các bag là giữ state qua BRAM-loss khi DDR còn điện. Không chứng minh lưu học qua mất nguồn toàn board; cần journal vào nonvolatile nếu sản phẩm đòi điều đó.

### F08 — Cấu trúc kiểm thử và vận hành có thể tạo vòng lặp PASS nhỏ

AGENTS/BRIDGE/old status và V3.1 bất nhất về milestone. Prereg cùng commit implementation không chứng minh chronology bằng Git; cũng không chứng minh người làm cố tình sửa threshold. Cách sửa là dùng một experiment revision mới, giữ fail cũ, freeze dataset/law trước run tiếp theo; không viết lại lịch sử.

U3Q OOC: tổng cell LUT~2437 khác report Slice LUTs=2389 vì cách đếm/packing; DSP=0 có thật. Timing OOC là NA do không constraint, chỉ được claim utilization-only. Current build helper default DSP=0 khi parser không thấy dòng cần sửa fail-closed, dù report lần này có dòng zero hợp lệ.

Các snapshot 98/98 chứng minh những vector đó, không bao phủ token+fire đồng thời, mọi overflow, reset pending và arbitrary stalls. Không cần vô hạn regression; thêm test khi có nguy cơ interface cụ thể.

## 6. Đánh giá Master V3.1

Đúng và nên giữ: một production datapath; FPGA sở hữu route/address/update; DDR lưu bulk; working set bounded; exact Top-K; phân biệt evidence level; không full scan; reset/persist/teacher-off; non-goals rõ.

Thiếu để thành thiết kế AI hữu dụng: training objective có generalization, thuật toán suy luận có variable binding/proof, dataset có ground truth độc lập, token/LM model compatibility, materialization nội dung evidence, index có coverage thật, chính sách UNKNOWN có test, full-chip resource allocation theo live hierarchy.

Gate14 compliance là cần thiết nhưng không đủ để chứng minh “hiểu”. Cần bổ sung capability acceptance có quan hệ mới, role reversal, evidence removal và reward ablation; không thay oracle cũ để che lỗi.

## 7. Quyết định đề xuất

1. Giữ các artifact board/XSim hẹp đã xác minh. Chưa cấp final Gate14/BOARD_PASS.
2. Không promote CHOSEN_PROFILE P4 dựa trên recall nhỏ/occupancy ID hiện tại. Sửa U4A trên data split và actual key law, đo cả selectivity, precision, full index coverage và tổng bytes.
3. Tiếp tục phần sửa protocol/key-capture U4 độc lập nếu đã được giao, nhưng không gọi đó là U4A quality closure.
4. Dùng bản `DESIGN_CANDIDATE.md` đi kèm như amendment được đề xuất cho V3.1. Tài liệu này không sửa master, oracle, artifact frozen hoặc tự mở program.
5. Không đặt phần trăm hoàn thành hay lịch “xong tối nay” từ số báo cáo PASS. Critical path là U4A quality → unified evidence/commit → bounded reasoning/learn proof → LM semantic path → full-chip/board.

## 8. Dữ liệu tham khảo phương pháp

- [bAbI tasks, Weston et al.](https://arxiv.org/abs/1502.05698): gợi ý tách thử chaining, deduction, induction; không dùng tên benchmark thay cho pass thực tế.
- [Contextual bandits, Li et al.](https://arxiv.org/abs/1003.0146): phản hồi chỉ cho lựa chọn đã thực hiện; phù hợp phân biệt reward-only với label/full-information.
- [Online Passive-Aggressive Algorithms](https://www.jmlr.org/papers/v7/crammer06a.html): lựa chọn cho học có nhãn, không tự áp vào reward-only khi host không được đưa positive winner.
- [Inductive logic programming at 30](https://arxiv.org/abs/2102.10556): phân biệt áp dụng luật logic với học luật mới.
- [AMD UG474: CLB slices](https://docs.amd.com/r/en-US/ug474_7Series_CLB/CLB-Slices): LUT/FF fit không đồng nghĩa slice placement fit.
- [Digilent Arty A7-100T](https://digilent.com/shop/arty-a7-100t-artix-7-fpga-development-board/): 256 MB DDR3L là dung lượng phần cứng; memory map khả dụng của thiết kế vẫn phải kiểm riêng.
