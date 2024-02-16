import 'dart:convert';
import 'package:langchain/langchain.dart';
import 'package:langchain_openai/langchain_openai.dart';
import 'package:pinecone/pinecone.dart';

String apikey = "1d1076c2-b383-426c-ac95-d65b59ac2592";
String openaiKey =
    "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"; //"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";
String environment = "gcp-starter";
String indexName = "quiz-cardmarker";

class LangChainService {
  final PineconeClient client = PineconeClient(
    apiKey: apikey,
    baseUrl: 'https://controller.$environment.pinecone.io',
  );
  final OpenAIEmbeddings embeddings = OpenAIEmbeddings(
    apiKey: openaiKey,
  );
  final OpenAI openAI = OpenAI(
      apiKey: openaiKey,
      defaultOptions:
          const OpenAIOptions(temperature: 0, model: "text-embedding-ada-002"));

// final langchainPinecone = Pinecone(
//   apiKey: apikey,
//   indexName: indexName,
//   embeddings: embeddings,
//   environment: environment,
// );

  LangChainService();

  Future<String> queryPineConeVectorStore(String query) async {
    print("started");
    try {
      final index = await client.describeIndex(
          indexName: indexName, environment: environment);
      final queryEmbedding = await embeddings.embedQuery(query);
      final result = await PineconeClient(
              apiKey: apikey,
              baseUrl:
                  'https://${index.name}-${index.projectId}.svc.${index.environment}.pinecone.io')
          .queryVectors(
        indexName: index.name,
        projectId: index.projectId,
        environment: index.environment,
        request: QueryRequest(
          topK: 10,
          vector: queryEmbedding,
          includeMetadata: true,
          includeValues: true,
        ),
      );
      if (result.matches.isNotEmpty) {
        final concatPageContent = result.matches.map((e) {
          if (e.metadata == null) return '';
          // check if the metadata has a 'pageContent' key
          if (e.metadata!.containsKey('pageContent')) {
            return e.metadata!['pageContent'];
          } else {
            return '';
          }
        }).join(' ');

        final docChain = StuffDocumentsQAChain(llm: openAI);
        final response = await docChain.call({
          'input_documents': [Document(pageContent: concatPageContent)],
          'question': query,
        });

        print(response);
        //client.deleteIndex(indexName: indexName);
        return response['output'];
      } else {
        return 'No results found';
      }
    } catch (e) {
      print(e);
      throw Exception('Error querying pinecone index');
    }
  }

  Future<void> uploadToPineconeIndex(List<Document> docs) async {
    String indexname = indexName;
    List indices = await client.listIndexes();
    if (indices.isNotEmpty) {
      await client.deleteIndex(indexName: indexName);
    }
    await client.createIndex(
        request: CreateIndexRequest(name: indexname, dimension: 1536),
        environment: "gcp-starter");
    try {
      print("Retrieving Pinecone index...");
      final index = await client.describeIndex(
          indexName: indexname, environment: environment);
      print('Pinecone index retrieved: ${index.name}');

      for (final doc in docs) {
        print('Processing document: ${doc.metadata['source']}');
        final txtPath = doc.metadata['source'] as String;
        final text = doc.pageContent.replaceAll(RegExp('/\n/g'), " ");

        const textSplitter = RecursiveCharacterTextSplitter(chunkSize: 1000);

        final chunks = textSplitter.createDocuments([text]);

        print('Text split into ${chunks.length} chunks');

        print(
            'Calling OpenAI\'s Embedding endpoint documents with ${chunks.length} text chunks ...');

        final chunksMap = chunks
            .map(
              (e) => Document(
                id: e.id,
                pageContent: e.pageContent.replaceAll(RegExp('/\n/g'), "  "),
                metadata: doc.metadata,
              ),
            )
            .toList();

        final embeddingArrays = await embeddings.embedDocuments(chunksMap);
        print('Finished embedding documents');
        print(
            'Creating ${chunks.length} vectors array with id, values, and metadata...');

        const batchSize = 100;
        for (int i = 0; i < chunks.length; i++) {
          final chunk = chunks[i];
          final embeddingArray = embeddingArrays[i];

          List<Vector> chunkVectors = [];

          final chunkVector =
              Vector(id: '${txtPath}_$i', values: embeddingArray, metadata: {
            ...chunk.metadata,
            'loc': jsonEncode(chunk.metadata['loc']),
            'pageContent': chunk.pageContent,
            'txtPath': txtPath,
          });

          chunkVectors.add(chunkVector);

          if (chunkVectors.length == batchSize || i == chunks.length - 1) {
            await PineconeClient(
                    apiKey: apikey,
                    baseUrl:
                        'https://${index.name}-${index.projectId}.svc.${index.environment}.pinecone.io')
                .upsertVectors(
              indexName: index.name,
              environment: index.environment,
              projectId: index.projectId,
              request: UpsertRequest(vectors: chunkVectors),
            );

            print('Pinecone index updated with ${chunkVectors.length} vectors');

            chunkVectors = [];
          }
        }
      }
    } catch (e) {
      print(e);
    }
  }
}
