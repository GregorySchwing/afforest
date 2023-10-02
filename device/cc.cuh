// Copyright (c) 2015, The Regents of the University of California (Regents)
// See LICENSE.txt for license details

#ifndef CC_CUH
#define CC_CUH

typedef int64_t OffsetID;
typedef int32_t NodeID;

void BenchmarkConnectedComponents_CSRThrust(NodeID nnodes,
                                            NodeID nedges,
                                            // nnodes*sizeof(NodeID) allocated on device
                                            NodeID *dev_comp,
                                            // SAMPLE_SIZE (1024)*sizeof(NodeID) allocated on device
                                            NodeID *dev_samples,
                                            // (nnodes + 1) * sizeof(OffsetID) allocated on device
                                            OffsetID *row_start_,
                                            // nedges * sizeof(NodeID_) allocated on device
                                            NodeID* edge_dst_);
#endif